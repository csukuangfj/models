#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_MX/$name/$type/es_MX-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_MX/$name/$type/es_MX-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_MX/$name/$type/MODEL_CARD

wget -qq https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/espeak-ng-data.tar.bz2
tar xf espeak-ng-data.tar.bz2
rm espeak-ng-data.tar.bz2

pip install piper-phonemize onnx onnxruntime==1.16.0

python3 ./vits-piper-es_MX.py
