#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/zh/zh_CN/$name/$type/zh_CN-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/zh/zh_CN/$name/$type/zh_CN-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/zh/zh_CN/$name/$type/MODEL_CARD

pip install piper-phonemize onnx onnxruntime==1.16.0

wget -qq https://raw.githubusercontent.com/csukuangfj/vits_chinese/master/aishell3/words.txt

echo "pwd: $PWD"

python3 ./vits-piper-zh_CN.py
head lexicon.txt
