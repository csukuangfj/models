#!/usr/bin/env python3

import json
import os
import re
from typing import Any, Dict

import onnx
from piper_phonemize import phonemize_espeak
from additional_words import get_additional_english_words


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


def generate_lexicon(name, t):
    config = load_config(f"en_US-{name}-{t}.onnx")
    words = read_lexicon()
    words.sort()
    num_words = len(words)
    print(num_words)

    batch = 5000
    i = 0
    word2phones = dict()
    while i < num_words:
        print(f"{i}/{num_words}, {i/num_words*100:.3f}%")
        this_batch = words[i : i + batch]
        i += batch
        for w in this_batch:
            phonemes = phonemize_espeak(w, config["espeak"]["voice"])[0]
            word2phones[w] = " ".join(phonemes)

    with open("lexicon.txt", "w", encoding="utf-8") as f:
        for w, p in word2phones.items():
            f.write(f"{w} {p}\n")


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


def load_config(model):
    with open(f"{model}.json", "r") as file:
        config = json.load(file)
    return config


def generate_tokens(config):
    id_map = config["phoneme_id_map"]
    with open("tokens.txt", "w", encoding="utf-8") as f:
        for s, i in id_map.items():
            f.write(f"{s} {i[0]}\n")
    print("Generated tokens.txt")


def main():
    t = os.environ.get("TYPE", None)
    if not t:
        print("Please provide the environment variable TYPE")
        return

    # thorsten or thorsten_emotional
    name = os.environ.get("NAME", None)
    if not t:
        print("Please provide the environment variable NAME")
        return
    print("type", t)

    print("generate lexicon")
    generate_lexicon(name, t)
    config = load_config(f"en_US-{name}-{t}.onnx")
    print("generate tokens")
    generate_tokens(config)
    print("add model metadata")
    _punctuation = ';:,.!?¡¿—…"«»“” '
    meta_data = {
        "model_type": "vits",
        "comment": "piper",
        "language": "English",
        "add_blank": 1,
        "n_speakers": config["num_speakers"],
        "sample_rate": config["audio"]["sample_rate"],
        "punctuation": " ".join(list(_punctuation)),
    }
    print(meta_data)
    add_meta_data(f"en_US-{name}-{t}.onnx", meta_data)


main()
