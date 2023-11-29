#!/usr/bin/env bash

lang=$LANG
echo "lang: $LANG"

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

# for en_US-lessac-medium.onnx
# export LANG=en_US
# export TYPE=lessac
# export NAME=medium

# if lang is en_US, then code is en
code=${lang:12:5}

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/$code/$lang/$name/$type/$lang-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/$code/$lang/$name/$type/$lang-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/$code/$lang/$name/$type/MODEL_CARD

wget -qq https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/espeak-ng-data.tar.bz2
tar xf espeak-ng-data.tar.bz2
rm espeak-ng-data.tar.bz2

pip install piper-phonemize onnx onnxruntime==1.16.0

python3 ./vits-piper.py
