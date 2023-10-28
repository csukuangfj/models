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

echo "pwd: $PWD"
head all-spanish-words.txt wordlist-spanish.txt

python3 ./vits-piper-es_ES.py
head lexicon.txt
