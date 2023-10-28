#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_ES/$name/$type/es_ES-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_ES/$name/$type/es_ES-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_ES/$name/$type/MODEL_CARD

pip install piper-phonemize onnx onnxruntime==1.16.0

wget -qq https://raw.githubusercontent.com/webpwnized/byepass/master/dictionaries/all-spanish-words.txt
wget -qq -O wordlist-spanish.txt https://raw.githubusercontent.com/ManiacDC/TypingAid/master/Wordlists/Wordlist%20Spanish.txt
wget -qq https://raw.githubusercontent.com/xavier-hernandez/spanish-wordlist/main/text/spanish_words.txt
wget -qq https://raw.githubusercontent.com/bitcoin/bips/master/bip-0039/spanish.txt
wget -qq https://github.com/titoBouzout/Dictionaries/raw/master/Spanish.dic

echo "pwd: $PWD"
head all-spanish-words.txt wordlist-spanish.txt spanish_words.txt spanish.txt Spanish.dic
file all-spanish-words.txt wordlist-spanish.txt spanish_words.txt spanish.txt Spanish.dic

python3 ./vits-piper-es_ES.py
head lexicon.txt
