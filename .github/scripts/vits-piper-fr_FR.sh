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
    wget -qq "https://raw.githubusercontent.com/tjiho/French-tts-model-piper/main/model%203/next.onnx.json"
    wget -qq "https://raw.githubusercontent.com/tjiho/French-tts-model-piper/main/model%203/next.onnx"
    mv -v next.onnx fr_FR-$name-$type.onnx
    mv -v next.onnx.json fr_FR-$name-$type.onnx.json
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

wget -qq https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/espeak-ng-data.tar.bz2
tar xf espeak-ng-data.tar.bz2
rm espeak-ng-data.tar.bz2

pip install piper-phonemize onnx onnxruntime==1.16.0

python3 ./vits-piper-fr_FR.py
