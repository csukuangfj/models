#!/usr/bin/env bash

set -ex

sudo apt-get install -q festival espeak-ng mbrola

python3 -m pip install -qq torch==${{ matrix.torch }}+cpu -f https://download.pytorch.org/whl/torch_stable.html numpy
python3 -m pip install -qq onnxruntime onnx soundfile
python3 -m pip install -qq scipy cython unidecode phonemizer

echo "Downloading vits"

git clone https://github.com/jaywalnut310/vits
pushd vits/monotonic_align
python3 setup.py build
ls -lh build/
ls -lh build/lib*/
ls -lh build/lib*/*/

cp build/lib*/monotonic_align/core*.so .
sed -i.bak s/.monotonic_align.core/.core/g ./__init__.py
git diff
popd

export PYTHONPATH=$PWD/vits:$PYTHONPATH

wget -q https://huggingface.co/csukuangfj/vits-vctk/resolve/main/pretrained_vctk.pth

wget -qq https://people.umass.edu/nconstan/CMU-IPA/CMU-in-IPA.zip
unzip CMU-in-IPA.zip

wget -qq https://github.com/webpwnized/byepass/raw/master/dictionaries/all-english-words.txt

echo "pwd: $PWD"
head CMU.in.IPA.txt all-english-words.txt

./vctk.py  \
  --config ./vits/configs/vctk_base.json \
  --checkpoint ./pretrained_vctk.pth
