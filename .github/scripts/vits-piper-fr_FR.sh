#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/fr_FR-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/fr_FR-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/MODEL_CARD

pip install piper-phonemize onnx onnxruntime==1.16.0

wget -qq https://github.com/frodonh/french-words/raw/main/french.txt



echo "pwd: $PWD"
head french.txt
file french.txt

python3 ./vits-piper-fr_FR.py
head lexicon.txt
