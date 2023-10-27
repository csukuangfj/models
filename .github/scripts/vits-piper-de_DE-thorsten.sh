#!/usr/bin/env bash

type=$TYPE
echo "type: $TYPE"

set -ex

wget https://huggingface.co/rhasspy/piper-voices/resolve/main/de/de_DE/thorsten/$type/de_DE-thorsten-$type.onnx
wget https://huggingface.co/rhasspy/piper-voices/resolve/main/de/de_DE/thorsten/$type/de_DE-thorsten-$type.onnx.json
wget https://huggingface.co/rhasspy/piper-voices/resolve/main/de/de_DE/thorsten/$type/MODEL_CARD

pip install piper-phonemize onnx onnxruntime==1.16.0

wget -O german.7z "https://downloads.sourceforge.net/project/germandict/german.7z?ts=gAAAAABlOnvekATxh2d2zse53x7JN4MUscbvCW073dv6CQrbQS-ekmrejSGcey1_MeJhNss6IKtI7BgpEH9ao1CIi4v2zMLULg%3D%3D&use_mirror=deac-riga&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgermandict%2Ffiles%2F"

sudo apt-get install -y p7zip

7z x ./german.7z
ls -lh

head austriazismen.txt LiesMich.txt autocomplete.txt german.dic helvetismen.txt variants.dic
file austriazismen.txt LiesMich.txt autocomplete.txt german.dic helvetismen.txt variants.dic

echo "pwd: $PWD"

python3 ./vits-piper-de_DE-thorsten.py
