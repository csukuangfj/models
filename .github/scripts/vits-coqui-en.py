#!/usr/bin/env python3

import re
from typing import Any, Dict

import onnx
from TTS.tts.configs.vits_config import VitsConfig
from TTS.tts.models.vits import Vits

from additional_words import get_additional_english_words


def get_phones(text, tokenizer):
    if tokenizer.text_cleaner:
        text = tokenizer.text_cleaner(text)
    if tokenizer.use_phonemes:
        text = tokenizer.phonemizer.phonemize(
            text,
            separator="",
            language=None,
        )
    return text


def read_lexicon():
    in_files = ["./CMU.in.IPA.txt", "all-english-words.txt"]
    words = set()

    new_words = get_additional_english_words()

    words = set()
    for w in new_words:
        words.add(w.lower())

    pattern = re.compile(r"^[a-zA-Z']+$")
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
                except:  # noqa
                    #  print(line)
                    continue

                if word in words:
                    # print("duplicate: ", word)
                    continue
                words.add(word)
    return list(words)


def generate_lexicon(vits):
    words = read_lexicon()
    words.sort()
    word2phones = dict()
    i = 0
    num_words = len(words)
    batch_size = 50

    skipped_words = []
    while i < num_words:
        if i % 10000 == 0:
            print(f"{i}/{num_words}, {i/num_words*100:.3f}%")

        this_batch = words[i : i + batch_size]  # noqa
        i += batch_size
        phones = get_phones(" ".join(this_batch), vits.tokenizer)
        phones_list = phones.split()
        if len(phones_list) != len(this_batch):
            skipped_words += this_batch
            print(f"skip a batch: {len(skipped_words)}/{num_words}")
            continue

        for w, phones in zip(this_batch, phones_list):
            word2phones[w] = " ".join(list(phones))

    print(len(skipped_words))
    for w in skipped_words:
        phones = get_phones(w, vits.tokenizer)
        word2phones[w] = " ".join(list(phones))

    with open("lexicon.txt", "w", encoding="utf-8") as f:
        for w, phones in word2phones.items():
            f.write(f"{w} {phones}\n")


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


def main():
    config = VitsConfig()
    config.load_json("config.json")

    # Initialize VITS model and load its checkpoint
    vits = Vits.init_from_config(config)
    vits.load_checkpoint(config, "model_file.pth")
    vits.export_onnx(output_path="model.onnx", verbose=False)

    meta_data = {
        "model_type": "vits",
        "comment": "coqui",  # For models from coqui-ai/TTS, it must be coqui
        "language": "English",
        "add_blank": int(vits.tokenizer.add_blank),
        "n_speakers": int(vits.num_speakers),
        "sample_rate": int(vits.ap.sample_rate),
        "punctuation": " ".join(list(vits.tokenizer.characters.punctuations)),
    }
    print("meta_data", meta_data)
    add_meta_data(filename="model.onnx", meta_data=meta_data)

    # Now generate tokens.txt
    with open("tokens.txt", "w", encoding="utf-8") as f:
        for token, idx in vits.tokenizer.characters._char_to_id.items():
            f.write(f"{token} {idx}\n")

    generate_lexicon(vits)


if __name__ == "__main__":
    main()
