#!/usr/bin/env bash

name=$NAME
echo "name: $name"

type=$TYPE
echo "type: $type"

set -ex

wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/fr_FR-$name-$type.onnx
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/fr_FR-$name-$type.onnx.json
wget -qq https://huggingface.co/rhasspy/piper-voices/resolve/main/fr/fr_FR/$name/$type/MODEL_CARD

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
