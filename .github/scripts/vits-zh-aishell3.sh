#!/usr/bin/env bash

python3 -m pip install -qq torch==1.13.0+cpu -f https://download.pytorch.org/whl/torch_stable.html numpy
python3 -m pip install onnxruntime onnx soundfile pypinyin
python3 -m pip install scipy cython unidecode phonemizer

git clone https://github.com/csukuangfj/vits_chinese
cd vits_chinese

pushd aishell3
wget -qq https://huggingface.co/csukuangfj/vits-zh-aishell3/resolve/main/G_AISHELL.pth

cd ../monotonic_align
python3 setup.py build

ls -lh build/
ls -lh build/lib*/
ls -lh build/lib*/*/

cp build/lib*/monotonic_align/core*.so .

sed -i.bak s/.monotonic_align.core/.core/g ./__init__.py
git diff
cd ..

mv -v ../polyphones_zh.py .
mv -v ../generate_lexicon_aishell3 .

python3 ./generate_lexicon_aishell3.py
python3 ./export_onnx_aishell3.py

ls -lh aishell3
echo "----------"
ls -lh

git status
