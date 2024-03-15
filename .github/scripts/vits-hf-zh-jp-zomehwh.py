#!/usr/bin/env python3

import sys

sys.path.insert(0, "VITS-fast-fine-tuning")

import re
from typing import Any, Dict, List

import onnx
import torch
import utils
from models import SynthesizerTrn
from text import _clean_text

from additional_words import get_additional_japanese_words
from polyphones_zh import word_list_zh


def read_lexicon_japanese():
    in_files = ["./15000-japanese-words.txt"]
    words = set()

    new_words = get_additional_japanese_words()

    words = set()
    for w in new_words:
        words.add(w.lower())

    for in_file in in_files:
        with open(in_file) as f:
            for line in f:
                word = line.strip()
                words.add(word)
    return list(words)


def get_phones_chinese(w, hps) -> List[str]:
    w = f"[ZH]{w}[ZH]"
    phones = _clean_text(w, hps.data.text_cleaners)
    if len(phones.strip()) == 0:
        return []
    return list(phones)[:-1]


def get_phones_japanese(w, hps) -> List[str]:
    w = f"[JA]{w}[JA]"
    phones = _clean_text(w, hps.data.text_cleaners)
    if len(phones.strip()) == 0:
        return []
    return list(phones)[:-1]


def generate_tokens(symbols):
    tokens = "tokens.txt"
    symbol_to_id = {s: i for i, s in enumerate(symbols)}
    with open(tokens, "w", encoding="utf-8") as f:
        for s, i in symbol_to_id.items():
            f.write(f"{s} {i}\n")
    print(f"Generated {tokens}")


def generate_lexicon(hps):
    symbol_to_id = {s: i for i, s in enumerate(hps.symbols)}
    words = set()
    with open("./words.txt", encoding="utf-8") as f:
        for line in f:
            word = line.strip()
            words.add(word)

    words = list(words)
    words.sort()

    word2phone = []
    for w in words:
        _phones = get_phones_chinese(w, hps)
        if len(_phones) == 0:
            print(f"Skip {w}")
            continue
        phones = []
        for p in _phones:
            if p not in symbol_to_id:
                continue
            phones.append(p)

        word2phone.append([w, " ".join(phones)])

    seen = set()
    for a, b in word_list_zh:
        if a in seen:
            print(f"skip {a}")
            continue
        seen.add(a)
        phones_list = []
        for i in b:
            _phones = get_phones_chinese(i, hps)

            if len(_phones) == 0:
                print(f"Skip {i}")
                continue

            phones = []
            for p in _phones:
                if p not in symbol_to_id:
                    continue
                phones.append(p)

            phones_list.extend(phones)

        phones = " ".join(phones_list)
        word2phone.append([a, phones])
    seen = set()

    words = read_lexicon_japanese()
    words.sort()
    for w in words:
        _phones = get_phones_japanese(w, hps)
        if len(_phones) == 0:
            print(f"Skip {w}")
            continue

        phones = []
        for p in _phones:
            if p not in symbol_to_id:
                continue
            phones.append(p)

        word2phone.append([w, " ".join(phones)])

    with open("lexicon.txt", "w", encoding="utf-8") as f:
        for w, phones in word2phone:
            f.write(f"{w} {phones}\n")
    print("Generated lexicon.txt")


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


@torch.no_grad()
def main():
    model_path = "G_953000.pth"
    config_path = "config.json"

    hps = utils.get_hparams_from_file(config_path)

    generate_tokens(hps.symbols)
    generate_lexicon(hps)

    net_g = SynthesizerTrn(
        len(hps.symbols),
        hps.data.filter_length // 2 + 1,
        hps.train.segment_size // hps.data.hop_length,
        n_speakers=hps.data.n_speakers,
        **hps.model,
    )
    _ = net_g.eval()
    _ = utils.load_checkpoint(model_path, net_g, None)

    x = torch.randint(low=1, high=50, size=(50,), dtype=torch.int64)
    x = x.unsqueeze(0)

    x_length = torch.tensor([x.shape[1]], dtype=torch.int64)
    noise_scale = torch.tensor([1], dtype=torch.float32)
    length_scale = torch.tensor([1], dtype=torch.float32)
    noise_scale_w = torch.tensor([1], dtype=torch.float32)
    sid = torch.tensor([0], dtype=torch.int64)

    model = OnnxModel(net_g)

    opset_version = 13

    filename = "vits-hf-zh-jp-zomehwh.onnx"

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
        "comment": "vits-hf-zh-jp-zomehwh",
        "language": "Chinese",
        "add_blank": int(hps.data.add_blank),
        "n_speakers": int(hps.data.n_speakers),
        "sample_rate": hps.data.sampling_rate,
        "punctuation": ", . : ; ! ? ， 。 ： ； ！ ？ 、",
    }
    print("meta_data", meta_data)
    add_meta_data(filename=filename, meta_data=meta_data)


if __name__ == "__main__":
    main()
