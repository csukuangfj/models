#!/usr/bin/env bash

set -ex

echo "name: $NAME"

export GIT_LFS_SKIP_SMUDGE=1
git clone https://huggingface.co/spaces/csukuangfj/vits-models
pushd vits-models/pretrained_models/$NAME
git lfs pull --include ${NAME}.pth
ls -lh
popd

pip install unidecode pyopenjtalk-prebuilt jamo pypinyin librosa cn2an onnx jieba torch==1.13.0+cpu -f https://download.pytorch.org/whl/torch_stable.html

python3 ./vits-zh-hf-models.py

ls -lh

wc -l lexicon.txt
head -n100 lexicon.txt
echo "--------------------"
tail -n100 lexicon.txt

echo "--------------------"

head -n100 tokens.txt
