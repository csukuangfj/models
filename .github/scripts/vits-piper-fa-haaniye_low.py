#!/usr/bin/env python3

import json
import os
from typing import Any, Dict

import onnx


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
    token2id = dict()
    with open("phonemes.txt") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            idx, token = line.split()
            token2id[token] = int(idx)
    token2id[" "] = 0

    with open("tokens.txt", "w", encoding="utf-8") as f:
        for s, i in token2id.items():
            f.write(f"{s} {i}\n")
    print("Generated tokens.txt")


def main():
    print("generate tokens")
    generate_tokens()

    print("add model metadata")
    meta_data = {
        "model_type": "vits",
        "comment": "piper",  # must be piper for models from piper
        "language": "Persian",
        "voice": "fa",
        "has_espeak": 1,
        "n_speakers": 1,
        "sample_rate": 22050,
    }
    print(meta_data)
    m = "fa-haaniye_low.onnx"
    add_meta_data(m, meta_data)


main()
