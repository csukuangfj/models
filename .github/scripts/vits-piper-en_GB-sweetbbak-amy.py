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
    m = "en_GB-sweetbbak-amy.onnx"
    config = load_config(m)

    print("generate tokens")
    generate_tokens(config)

    print("add model metadata")
    meta_data = {
        "model_type": "vits",
        "comment": "piper",  # must be piper for models from piper
        "language": "English",
        "voice": config["espeak"]["voice"],  # e.g., en-us
        "has_espeak": 1,
        "n_speakers": config["num_speakers"],
        "sample_rate": config["audio"]["sample_rate"],
    }
    print(meta_data)
    add_meta_data(m, meta_data)


main()
