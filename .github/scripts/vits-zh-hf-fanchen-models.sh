#!/usr/bin/env bash

set -ex

echo "name: $NAME"

pip install unidecode onnx onnxruntime pyopenjtalk jamo \
  Cython scipy \
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

wget -q https://huggingface.co/spaces/lkz99/tts_model/resolve/main/G_${NAME}_latest.json
wget -q https://huggingface.co/spaces/lkz99/tts_model/resolve/main/G_${NAME}_latest.pth
wget -q https://raw.githubusercontent.com/csukuangfj/vits_chinese/master/aishell3/words.txt
ls -lh

./generate-lexicon-zh-hf-fanchen-models.py
./export-onnx-zh-hf-fanchen-models.py

ls -lh
