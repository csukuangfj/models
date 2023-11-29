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


lang_map = {
    "da_DK": "Danish",
    "el_GR": "Greek",
    "fi_FI": "Finnish",
    "hu_HU": "Hungarian",
    "is_IS": "Icelandic",
    "it_IT": "Italian",
    "ka_GE": "Georgian",
    "kk_KZ": "Kazakh",
    "lb_LU": "Luxembourgish",
    "ne_NP": "Nepali",
    "nl_BE": "Dutch",
    "nl_NL": "Dutch",
    "no_NO": "Norwegian",
    "pl_PL": "Polish",
    "pt_BR": "Portuguese",
    "pt_PT": "Portuguese",
    "ro_RO": "Romanian",
    "sk_SK": "Slovak",
    "sr_RS": "Serbian",
    "sv_SE": "Swedish",
    "sw_CD": "Swahili",
    "tr_TR": "Turkish",
    "vi_VN": "Vietnamese",
}


# for en_US-lessac-medium.onnx
# export LANG=en_US
# export TYPE=lessac
# export NAME=medium
def main():
    lang = os.environ.get("LANG", None)
    if not lang:
        print("Please provide the environment variable LANG")
        return

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

    config = load_config(f"${lang}-{name}-{t}.onnx")

    print("generate tokens")
    generate_tokens(config)

    print("add model metadata")
    meta_data = {
        "model_type": "vits",
        "comment": "piper",  # must be piper for models from piper
        "language": lang_map[lang],
        "voice": config["espeak"]["voice"],  # e.g., en-us
        "has_espeak": 1,
        "n_speakers": config["num_speakers"],
        "sample_rate": config["audio"]["sample_rate"],
    }
    print(meta_data)
    add_meta_data(f"{lang}-{name}-{t}.onnx", meta_data)


main()
