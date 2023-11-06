#!/usr/bin/env python3
from test_aishell3 import load_pinyin_dict, Pinyin, MyConverter, chinese_to_phonemes
from text.symbols import symbols
from polyphones_zh import word_list_zh

additional_words = [
    ("a", "^ ei1 #0 #0"),
    ("b", "b i1 #0 #0"),
    ("c", "s ei1 #0 #0"),
    ("d", "d i1 #0 #0"),
    ("e", "^ i1 #0 #0"),
    ("f", "^ ei1 f u1 #0 #0"),
    ("g", "j i1 #0 #0"),
    ("h", "^ ei1 q i1 #0 #0"),
    ("i", "^ ai1 #0 #0"),
    ("j", "j ie1 #0 #0"),
    ("k", "k ei1 #0 #0"),
    ("l", "^ ei1 ^ ao1 #0 #0"),
    ("m", "^ ei1 m u1 #0 #0"),
    ("n", "^ ei1 n i1 #0 #0"),
    ("o", "^ ou1 #0 #0"),
    ("p", "p i1 #0 #0"),
    ("q", "k ou1 ^ iou4 #0 #0"),
    ("r", "^ a1 #0 #0"),
    ("s", "^ ei1 s ii1 #0 #0"),
    ("t", "t i1 #0 #0"),
    ("u", "^ iou1 #0 #0"),
    ("v", "^ uei1 #0 #0"),
    ("w", "d a1 b u1 l iou1 #0 #0"),
    ("x", "^ ai1 k e1 s ii1 #0 #0"),
    ("y", "^ uai1 #0 #0"),
    ("z", "z ei1 #0 #0"),
]


def generate_tokens():
    tokens = "aishell3/tokens.txt"
    with open(tokens, "w", encoding="utf-8") as f:
        for i, s in enumerate(symbols):
            f.write(f"{s} {i}\n")
    print(f"Generated {tokens}")


def generate_lexicon():
    words = set()
    with open("./aishell3/所有可显汉字库.txt", encoding="utf-8") as f:
        for line in f:
            if "," not in line:
                continue
            word = line.strip().split()[-1]
            words.add(word)

    words = list(words)
    words.sort()
    with open("./aishell3/words.txt", "w", encoding="utf-8") as f:
        for w in words:
            print(w, file=f)

    load_pinyin_dict()
    pinyin_parser = Pinyin(MyConverter())

    lexicon = "./aishell3/lexicon.txt"
    with open(lexicon, "w", encoding="utf-8") as f:
        for w in words:
            phonemes = chinese_to_phonemes(pinyin_parser, w)
            phonemes = phonemes.split()
            # Remove the first sil, the last two sil and eos
            phonemes = phonemes[1:-2]
            phonemes = " ".join(phonemes)
            f.write(f"{w} {phonemes}\n")
        seen = set()
        for a, b in word_list_zh:
            if a in seen:
                print(f"skip {a}")
                continue
            seen.add(a)
            phonemes = chinese_to_phonemes(pinyin_parser, b)
            phonemes = phonemes.split()
            # Remove the first sil, the last two sil and eos
            phonemes = phonemes[1:-2]
            phonemes = " ".join(phonemes)
            #  print(a, b, phonemes)
            f.write(f"{a} {phonemes}\n")

        for a, b in additional_words:
            f.write(f"{a} {b}\n")

        print(f"added {len(seen)} word group")

    print(f"Generated {lexicon}")


def main():
    generate_tokens()
    generate_lexicon()


if __name__ == "__main__":
    main()
