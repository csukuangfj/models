#!/usr/bin/env bash

set -ex

wget -qq https://github.com/sweetbbak/Neural-Amy-TTS/releases/download/v1/ivona_hq.tar.lzma
tar --lzma --extract --file ivona_hq.tar.lzma
ls -lh
ls -lh ivona-8-23
mv ivona-8-23/* .
ls -lh amy.onnx
ls -lh amy.onnx.json

mv -v amy.onnx en_GB-sweetbbak-amy.onnx
mv -v amy.onnx.json en_GB-sweetbbak-amy.onnx.json

cat >README.md <<EOF
# Introduction
#
This model is converted from the following repository.
https://github.com/sweetbbak/Neural-Amy-TTS
EOF

wget -qq https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/espeak-ng-data.tar.bz2
tar xf espeak-ng-data.tar.bz2
rm espeak-ng-data.tar.bz2

pip install piper-phonemize onnx onnxruntime==1.16.0

python3 ./vits-piper-en_GB-sweetbbak-amy.py
