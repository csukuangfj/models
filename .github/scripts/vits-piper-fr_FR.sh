#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

if [[ $name == "tjiho" ]]; then
  if [[ $type == "model1" ]]; then
    wget -qq "https://raw.githubusercontent.com/tjiho/French-tts-model-piper/main/model%201/tom1.onnx.json"
    wget -qq "https://raw.githubusercontent.com/tjiho/French-tts-model-piper/main/model%201/tom1.onnx"
    mv -v tom1.onnx fr_FR-$name-$type.onnx
    mv -v tom1.onnx.json fr_FR-$name-$type.onnx.json
  elif [[ $type == "model2" ]]; then
    wget -qq "https://raw.githubusercontent.com/tjiho/French-tts-model-piper/main/model%202/tom2.onnx.json"
    wget -qq "https://raw.githubusercontent.com/tjiho/French-tts-model-piper/main/model%202/tom2.onnx"

    mv -v tom2.onnx fr_FR-$name-$type.onnx
    mv -v tom2.onnx.json fr_FR-$name-$type.onnx.json
  elif [[ $type == "model3" ]]; then
    wget -qq "https://raw.githubusercontent.com/tjiho/French-tts-model-piper/main/model%203/tom3.onnx.json"
    wget -qq "https://raw.githubusercontent.com/tjiho/French-tts-model-piper/main/model%203/tom3.onnx"
    mv -v tom3.onnx fr_FR-$name-$type.onnx
    mv -v tom3.onnx.json fr_FR-$name-$type.onnx.json
  else
    echo "unknown type: $type for name: $name"
    exit 1
  fi

  echo "This model is converted from https://github.com/tjiho/French-tts-model-piper" > MODEL_CARD
else
  wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/fr_FR-$name-$type.onnx
  wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/fr_FR-$name-$type.onnx.json
  wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/MODEL_CARD
fi

pip install piper-phonemize onnx onnxruntime==1.16.0

# see http://www.3zsoftware.com/en/lists.php
wget -qq https://github.com/frodonh/french-words/raw/main/french.txt
wget -qq http://www.3zsoftware.com/listes/gutenberg.zip
unzip gutenberg.zip

wget -qq http://www.3zsoftware.com/listes/ods4.zip
unzip ods4.zip

wget -qq http://www.3zsoftware.com/listes/ods5.zip
unzip ods5.zip

wget -qq http://www.3zsoftware.com/listes/ods6.zip
unzip ods6.zip

wget -qq http://www.3zsoftware.com/listes/pli07.zip
unzip pli07.zip


echo "pwd: $PWD"
head french.txt gutenberg.txt ods4.txt ods5.txt ods6.txt pli07.txt
file french.txt gutenberg.txt ods4.txt ods5.txt ods6.txt pli07.txt

python3 ./vits-piper-fr_FR.py
head lexicon.txt
