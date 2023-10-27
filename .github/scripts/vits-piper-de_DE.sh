#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/de/de_DE/$name/$type/de_DE-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/de/de_DE/$name/$type/de_DE-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/de/de_DE/$name/$type/MODEL_CARD

pip install piper-phonemize onnx onnxruntime==1.16.0

wget -qq -O german.7z "https://downloads.sourceforge.net/project/germandict/german.7z?ts=gAAAAABlOnvekATxh2d2zse53x7JN4MUscbvCW073dv6CQrbQS-ekmrejSGcey1_MeJhNss6IKtI7BgpEH9ao1CIi4v2zMLULg%3D%3D&use_mirror=deac-riga&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgermandict%2Ffiles%2F"

sudo apt-get install -y p7zip

7z x ./german.7z
ls -lh

head austriazismen.txt LiesMich.txt autocomplete.txt german.dic helvetismen.txt variants.dic
file austriazismen.txt LiesMich.txt autocomplete.txt german.dic helvetismen.txt variants.dic

echo "pwd: $PWD"

python3 ./vits-piper-de_DE.py
