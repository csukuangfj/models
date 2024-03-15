#!/usr/bin/env python3
# Copyright    2023  Xiaomi Corp.        (authors: Fangjun Kuang)

import argparse
import re
import sys
from pathlib import Path
from typing import Any, Dict

import commons
import onnx
import torch
import utils
from models import SynthesizerTrn
from onnxruntime.quantization import QuantType, quantize_dynamic
from phonemizer import phonemize
from text import text_to_sequence
from text.symbols import _punctuation, symbols

from additional_words import get_additional_english_words


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--config",
        type=str,
        required=True,
        help="""Path to vctk_base.json.
        You can find it at
        https://huggingface.co/csukuangfj/vits-vctk/resolve/main/vctk_base.json
        """,
    )

    parser.add_argument(
        "--checkpoint",
        type=str,
        required=True,
        help="""Path to the checkpoint file.
        You can find it at
        https://huggingface.co/csukuangfj/vits-vctk/resolve/main/pretrained_vctk.pth
        """,
    )

    return parser.parse_args()


def read_lexicon():
    in_files = ["./CMU.in.IPA.txt", "all-english-words.txt"]
    words = set()

    new_words = get_additional_english_words()

    words = set()
    for w in new_words:
        words.add(w.lower())

    pattern = re.compile(r"^[a-zA-Z'-\.]+$")
    for in_file in in_files:
        with open(in_file) as f:
            for line in f:
                try:
                    line = line.strip()
                    word = line.split(",")[0]
                    word = word.strip().lower()
                    if not pattern.match(word):
                        #  print(line, "word is", word)
                        continue
                except:
                    #  print(line)
                    continue

                if word in words:
                    # print("duplicate: ", word)
                    continue
                words.add(word)
    return list(words)


def generate_lexicon():
    words = read_lexicon()
    words.sort()

    num_words = len(words)
    batch = 5000
    i = 0
    word2ipa = dict()
    while i < num_words:
        print(f"{i}/{num_words}, {i/num_words*100:.3f}%")
        this_batch = words[i : i + batch]
        i += batch
        phonemes = phonemize(
            this_batch,
            language="en-us",
            backend="espeak",
            strip=True,
            preserve_punctuation=True,
            with_stress=True,
        )
        for w, p in zip(this_batch, phonemes):
            word2ipa[w] = " ".join(list(p))

    with open("lexicon.txt", "w", encoding="utf-8") as f:
        for w, p in word2ipa.items():
            f.write(f"{w} {p}\n")


class OnnxModel(torch.nn.Module):
    def __init__(self, model: SynthesizerTrn):
        super().__init__()
        self.model = model

    def forward(
        self,
        x,
        x_lengths,
        noise_scale=1,
        length_scale=1,
        noise_scale_w=1.0,
        sid=0,
        max_len=None,
    ):
        return self.model.infer(
            x=x,
            x_lengths=x_lengths,
            sid=sid,
            noise_scale=noise_scale,
            length_scale=length_scale,
            noise_scale_w=noise_scale_w,
            max_len=max_len,
        )[0]


def get_text(text, hps):
    text_norm = text_to_sequence(text, hps.data.text_cleaners)
    if hps.data.add_blank:
        text_norm = commons.intersperse(text_norm, 0)
    text_norm = torch.LongTensor(text_norm)
    return text_norm


def check_args(args):
    assert Path(args.config).is_file(), args.config
    assert Path(args.checkpoint).is_file(), args.checkpoint


def add_meta_data(filename: str, meta_data: Dict[str, Any]):
    """Add meta data to an ONNX model. It is changed in-place.

    Args:
      filename:
        Filename of the ONNX model to be changed.
      meta_data:
        Key-value pairs.
    """
    model = onnx.load(filename)
    for key, value in meta_data.items():
        meta = model.metadata_props.add()
        meta.key = key
        meta.value = str(value)

    onnx.save(model, filename)


def generate_tokens():
    with open("tokens.txt", "w", encoding="utf-8") as f:
        for i, s in enumerate(symbols):
            f.write(f"{s} {i}\n")
    print("Generated tokens.txt")


@torch.no_grad()
def main():
    generate_lexicon()
    args = get_args()
    check_args(args)

    generate_tokens()

    hps = utils.get_hparams_from_file(args.config)

    net_g = SynthesizerTrn(
        len(symbols),
        hps.data.filter_length // 2 + 1,
        hps.train.segment_size // hps.data.hop_length,
        n_speakers=hps.data.n_speakers,
        **hps.model,
    )
    _ = net_g.eval()

    _ = utils.load_checkpoint(args.checkpoint, net_g, None)

    x = get_text("Liliana is the most beautiful assistant", hps)
    x = x.unsqueeze(0)

    x_length = torch.tensor([x.shape[1]], dtype=torch.int64)
    noise_scale = torch.tensor([1], dtype=torch.float32)
    length_scale = torch.tensor([1], dtype=torch.float32)
    noise_scale_w = torch.tensor([1], dtype=torch.float32)
    sid = torch.tensor([0], dtype=torch.int64)

    model = OnnxModel(net_g)

    opset_version = 13

    filename = "vits-vctk.onnx"

    torch.onnx.export(
        model,
        (x, x_length, noise_scale, length_scale, noise_scale_w, sid),
        filename,
        opset_version=opset_version,
        input_names=[
            "x",
            "x_length",
            "noise_scale",
            "length_scale",
            "noise_scale_w",
            "sid",
        ],
        output_names=["y"],
        dynamic_axes={
            "x": {0: "N", 1: "L"},  # n_audio is also known as batch_size
            "x_length": {0: "N"},
            "y": {0: "N", 2: "L"},
        },
    )
    meta_data = {
        "model_type": "vits",
        "comment": "vctk",
        "language": "English",
        "add_blank": int(hps.data.add_blank),
        "n_speakers": int(hps.data.n_speakers),
        "sample_rate": hps.data.sampling_rate,
        "punctuation": " ".join(list(_punctuation)),
    }
    print("meta_data", meta_data)
    add_meta_data(filename=filename, meta_data=meta_data)

    print("Generate int8 quantization models")

    filename_int8 = "vits-vctk.int8.onnx"
    quantize_dynamic(
        model_input=filename,
        model_output=filename_int8,
        weight_type=QuantType.QUInt8,
    )

    print(f"Saved to {filename} and {filename_int8}")


if __name__ == "__main__":
    main()
