#!/usr/bin/env bash

set -ex

name=$NAME
if [[ $name == "uk-mai" ]]; then
  wget -q https://coqui.gateway.scarf.sh/v0.8.0_models/tts_models--uk--mai--vits.zip
  unzip tts_models--uk--mai--vits.zip

  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/snapshots/4045181fbc0f09f97637451ca79cd1b73bc0aed8
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/snapshots/4045181fbc0f09f97637451ca79cd1b73bc0aed8
  sudo chmod a=rwx /root
  sudo chmod a=rwx /root/.cache
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/snapshots/4045181fbc0f09f97637451ca79cd1b73bc0aed8

  sudo cp -v tts_models--uk--mai--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/snapshots/4045181fbc0f09f97637451ca79cd1b73bc0aed8

  sudo ls -lh /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/snapshots/4045181fbc0f09f97637451ca79cd1b73bc0aed8
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/snapshots/4045181fbc0f09f97637451ca79cd1b73bc0aed8/speaker_ids.json
  sudo ls -lh /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-uk/snapshots/4045181fbc0f09f97637451ca79cd1b73bc0aed8

  ls -lh tts_models--uk--mai--vits
  cp -v tts_models--uk--mai--vits/model_file.pth.tar ./model_file.pth
  cp -v tts_models--uk--mai--vits/*.json ./
  ls -lh
else
  echo "Unsupported name: $name"
  exit 1
fi

pip install -q TTS onnx onnxruntime

python3 ./vits-coqui-uk.py
ls -lh *.onnx
