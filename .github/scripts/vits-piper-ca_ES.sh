#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

# for ca_ES-upc_pau-x_low.onnx
# export TYPE=upc_pau
# export NAME=x_low

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/ca/ca_ES/$name/$type/ca_ES-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/ca/ca_ES/$name/$type/ca_ES-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/ca/ca_ES/$name/$type/MODEL_CARD

wget -qq https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/espeak-ng-data.tar.bz2
tar xf espeak-ng-data.tar.bz2
rm espeak-ng-data.tar.bz2

pip install piper-phonemize onnx onnxruntime==1.16.0

python3 ./vits-piper-ca_ES.py
