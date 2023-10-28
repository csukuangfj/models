#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/$name/$type/en_US-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/$name/$type/en_US-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/$name/$type/MODEL_CARD

pip install piper-phonemize onnx onnxruntime==1.16.0

wget -qq https://people.umass.edu/nconstan/CMU-IPA/CMU-in-IPA.zip
unzip CMU-in-IPA.zip

wget -qq https://github.com/webpwnized/byepass/raw/master/dictionaries/all-english-words.txt

echo "pwd: $PWD"
head CMU.in.IPA.txt all-english-words.txt

python3 ./vits-piper-en_US.py
head lexicon.txt
