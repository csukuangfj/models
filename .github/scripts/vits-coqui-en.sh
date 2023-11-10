#!/usr/bin/env bash

set -ex

name=$NAME
if [[ $name == "ljspeech-vits" ]]; then
  wget -q https://coqui.gateway.scarf.sh/v0.6.1_models/tts_models--en--ljspeech--vits.zip
  unzip tts_models--en--ljspeech--vits.zip
  mv -v tts_models--en--ljspeech--vits/model_file.pth ./
  mv -v tts_models--en--ljspeech--vits/config.json ./
elif [[ $name == "ljspeech-vits-neon" ]]; then
  wget -q https://coqui.gateway.scarf.sh/v0.8.0_models/tts_models--en--ljspeech--vits.zip
  unzip tts_models--en--ljspeech--vits.zip
  mv -v tts_models--en--ljspeech--vits/model_file.pth.tar ./model_file.pth
  mv -v tts_models--en--ljspeech--vits/config.json ./
elif [[ $name == "vctk-vits" ]]; then
  wget -q https://coqui.gateway.scarf.sh/v0.6.1_models/tts_models--en--vctk--vits.zip
  unzip tts_models--en--vctk--vits.zip
  mv -v tts_models--en--vctk--vits/config.json ./
  cp -v tts_models--en--vctk--vits/speaker_ids.json ./
  mv -v tts_models--en--vctk--vits/model_file.pth ./
  sudo mkdir -p /home/julian/.local/share/tts/tts_models--en--vctk--vits
  sudo cp -v speaker_ids.json /home/julian/.local/share/tts/tts_models--en--vctk--vits
elif [[ $name == "jenny-jenny" ]]; then
  wget -q https://coqui.gateway.scarf.sh/v0.14.0_models/tts_models--en--jenny--jenny.zip
  unzip tts_models--en--jenny--jenny.zip
  mv -v tts_models--en--jenny--jenny/config.json ./
  mv -v tts_models--en--jenny--jenny/model.pth ./
fi

pip install -q TTS onnx onnxruntime
sudo apt-get install -q -y espeak-ng espeak

wget -qq https://people.umass.edu/nconstan/CMU-IPA/CMU-in-IPA.zip
unzip CMU-in-IPA.zip

wget -qq https://github.com/webpwnized/byepass/raw/master/dictionaries/all-english-words.txt

echo "pwd: $PWD"
head CMU.in.IPA.txt all-english-words.txt

python3 ./vits-coqui-en.py

head lexicon.txt
echo "----"
tail lexicon.txt
echo

wc -l lexicon.txt

ls -lh
