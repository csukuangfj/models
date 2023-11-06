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

wget -q https://raw.githubusercontent.com/csukuangfj/vits_chinese/master/aishell3/words.txt
wget -q https://raw.githubusercontent.com/csukuangfj/vits_chinese/master/polyphones_zh.py

python3 ./vits-zh-hf-models.py
