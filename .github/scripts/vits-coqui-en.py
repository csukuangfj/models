#!/usr/bin/env python3

from typing import Any, Dict

import onnx
from TTS.tts.configs.vits_config import VitsConfig
from TTS.tts.models.vits import Vits


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

    assert vits.config.use_phonemes
    assert vits.config.phoneme_language in ["en", "zh-cn"]

    if vits.config.phoneme_language == "en":
        language = "English"
        voice = "en-us"
    elif vits.config.phoneme_language == "zh-cn":
        language = "Chinese"
        voice = "cmn"

    vits.load_checkpoint(config, "model_file.pth")
    vits.export_onnx(output_path="model.onnx", verbose=False)

    meta_data = {
        "model_type": "vits",
        "comment": "coqui",  # For models from coqui-ai/TTS, it must be coqui
        "language": language,
        "voice": voice,
        "has_espeak": 1,
        "add_blank": int(vits.config.add_blank),
        "blank_id": vits.tokenizer.characters.blank_id,
        "n_speakers": vits.config.model_args.num_speakers,
        "use_eos_bos": int(vits.tokenizer.use_eos_bos),
        "bos_id": vits.tokenizer.characters.bos_id,
        "eos_id": vits.tokenizer.characters.eos_id,
        "sample_rate": int(vits.ap.sample_rate),
    }
    print("meta_data", meta_data)
    add_meta_data(filename="model.onnx", meta_data=meta_data)

    # Now generate tokens.txt
    with open("tokens.txt", "w", encoding="utf-8") as f:
        for token, idx in vits.tokenizer.characters._char_to_id.items():
            f.write(f"{token} {idx}\n")


if __name__ == "__main__":
    main()
