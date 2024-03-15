#!/usr/bin/env bash

set -ex

wget -q https://github.com/MycroftAI/mimic3-voices/raw/master/voices/fa/haaniye_low/generator.onnx
wget -q https://raw.githubusercontent.com/MycroftAI/mimic3-voices/master/voices/fa/haaniye_low/config.json
wget -q https://raw.githubusercontent.com/MycroftAI/mimic3-voices/master/voices/fa/haaniye_low/phonemes.txt

mv generator.onnx fa-haaniye_low.onnx
mv config.json fa-haaniye_low.onnx.json

cat >README.md <<EOF
# Introduction
#
This model is converted from the following repository.
https://github.com/MycroftAI/mimic3-voices/tree/master/voices/fa/haaniye_low
EOF

wget -qq https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/espeak-ng-data.tar.bz2
tar xf espeak-ng-data.tar.bz2
rm espeak-ng-data.tar.bz2

pip install piper-phonemize onnx onnxruntime==1.16.0

python3 ./vits-piper-fa-haaniye_low.py
