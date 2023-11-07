#!/usr/bin/env bash

set -ex

pip install unidecode onnx onnxruntime pyopenjtalk jamo \
  Cython scipy \
  jieba inflect \
  ko_pron pypinyin cn2an indic_transliteration eng_to_ipa num_thai \
  torch==1.13.0+cpu -f https://download.pytorch.org/whl/torch_stable.html

git clone https://github.com/Plachtaa/VITS-fast-fine-tuning
pushd VITS-fast-fine-tuning/monotonic_align

python3 setup.py build

ls -lh build/
ls -lh build/lib*/
ls -lh build/lib*/*/

cp build/lib*/monotonic_align/core*.so .

sed -i.bak s/.monotonic_align.core/.core/g ./__init__.py
git diff

popd

wget -q https://huggingface.co/spaces/zomehwh/vits-uma-genshin-honkai/resolve/main/model/G_953000.pth
wget -q https://huggingface.co/spaces/zomehwh/vits-uma-genshin-honkai/resolve/main/model/config.json
wget -q https://raw.githubusercontent.com/csukuangfj/vits_chinese/master/aishell3/words.txt

wget -qq https://people.umass.edu/nconstan/CMU-IPA/CMU-in-IPA.zip
unzip CMU-in-IPA.zip

wget -qq https://github.com/webpwnized/byepass/raw/master/dictionaries/all-english-words.txt

echo "pwd: $PWD"
head CMU.in.IPA.txt all-english-words.txt

./vits-hf-zh-jp-en-zomehwh.py

ls -lh

wc -l lexicon.txt
head -n100 lexicon.txt
echo "--------------------"
tail -n100 lexicon.txt

echo "--------------------"

head -n100 tokens.txt
