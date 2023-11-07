#!/usr/bin/env python3
import sys

sys.path.insert(0, "VITS-fast-fine-tuning")


import os
from typing import List

import utils
from text import _clean_text

from polyphones_zh import word_list_zh


def get_phones(w, hps) -> List[str]:
    w = f"[ZH]{w}[ZH]"
    phones = _clean_text(w, hps.data.text_cleaners)
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
        phones = get_phones(w, hps)
        oov = False
        for p in phones:
            if p not in symbol_to_id:
                print(f"{p} not in symbol_to_id, skip {w}")
                oov = True
                break
        if oov:
            print(f"skip {w}")
            continue

        word2phone.append([w, " ".join(phones)])

    seen = set()
    for a, b in word_list_zh:
        if a in seen:
            print(f"skip {a}")
            continue
        seen.add(a)
        oov = False
        phones_list = []
        for i in b:
            phones = get_phones(i, hps)
            for p in phones:
                if p not in symbol_to_id:
                    print(f"{p} not in symbol_to_id, skip {w}")
                    oov = True
                    break

            phones_list.extend(phones)
        if oov:
            print(f"Skip {a}")
            continue

        phones = " ".join(phones_list)
        word2phone.append([a, phones])

    with open("lexicon.txt", "w", encoding="utf-8") as f:
        for w, phones in word2phone:
            print(f"{w} {phones}\n", file=f)
    print("Generated lexicon.txt")


def main():
    name = os.environ.get("NAME", None)
    if not name:
        print("Please provide the environment variable NAME")
        return

    print("name", name)
    config_path = f"G_{name}_latest.json"

    hps = utils.get_hparams_from_file(config_path)
    print(type(hps), hps)
    generate_tokens(hps.symbols)
    generate_lexicon(hps)


if __name__ == "__main__":
    main()
