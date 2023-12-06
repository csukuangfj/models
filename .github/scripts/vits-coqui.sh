#!/usr/bin/env bash

set -ex

name=$NAME

lang=$(echo $name | cut -d "-" -f1)

export LANG=$lang

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
elif [[ $name == 'bg-cv' || $name == "cs-cv" || $name == "da-cv" || $name == "et-cv" || $name == "ga-cv" ]] || \
     [[ $name == 'hr-cv' || $name == "lt-cv" || $name == "lv-cv" || $name == "mt-cv" ]] || \
     [[ $name == 'pt-cv' || $name == "ro-cv" || $name == "sk-cv" || $name == "sl-cv" ]] || \
     [[ $name == 'sv-cv' ]] || \
     [[ $name == "es-css10" ]] || \
     [[ $name == "fr-css10" ]] || \
     [[ $name == "nl-css10" ]] || \
     [[ $name == "de-css10" ]] || \
     [[ $name == "hu-css10" ]] || \
     [[ $name == "fi-css10" ]] || \
     [[ $name == "pl-mai_female" ]]; then
  lang=$(echo $name | cut -d "-" -f1)
  dataset=$(echo $name | cut -d "-" -f2)
  url=https://coqui.gateway.scarf.sh/v0.8.0_models/tts_models--$lang--$dataset--vits.zip
  wget -q $url
  zipname=$(basename $url)
  name_no_ext=$(basename -s .zip $zipname)
  unzip $zipname
  cp $name_no_ext/model_file.pth.tar ./model_file.pth
  cp $name_no_ext/*.json ./
  ls -lh
elif [[ $name == "bn-custom_male" ]]; then
  url=https://coqui.gateway.scarf.sh/v0.13.3_models/tts_models--bn--custom--vits_male.zip
  wget -q $url
  zipname=$(basename $url)
  name_no_ext=$(basename -s .zip $zipname)
  unzip $zipname
  cp $name_no_ext/model_file.pth ./model_file.pth
  cp $name_no_ext/*.json ./
  ls -lh
elif [[ $name == "bn-custom_female" ]]; then
  url=https://coqui.gateway.scarf.sh/v0.13.3_models/tts_models--bn--custom--vits_female.zip
  wget -q $url
  zipname=$(basename $url)
  name_no_ext=$(basename -s .zip $zipname)
  unzip $zipname
  cp $name_no_ext/model_file.pth ./model_file.pth
  cp $name_no_ext/*.json ./
  ls -lh
else
  echo "Unsupported name: $name"
  exit 1
fi


if [[ $name == "bg-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-bg/snapshots/cb15b38ac4131e2061b171743366bd0864ae5dee
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-bg/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-bg/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-bg/snapshots/cb15b38ac4131e2061b171743366bd0864ae5dee
  cp -v tts_models--bg--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-bg/snapshots/cb15b38ac4131e2061b171743366bd0864ae5dee
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-bg/snapshots/cb15b38ac4131e2061b171743366bd0864ae5dee/speaker_ids.json
fi

if [[ $name == "cs-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-cs/snapshots/5e7c4c5ddf06d90f90b24b6c33035a1019869642
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-cs/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-cs/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-cs/snapshots/5e7c4c5ddf06d90f90b24b6c33035a1019869642
  cp -v tts_models--cs--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-cs/snapshots/5e7c4c5ddf06d90f90b24b6c33035a1019869642
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-cs/snapshots/5e7c4c5ddf06d90f90b24b6c33035a1019869642/speaker_ids.json
fi

if [[ $name == "da-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-da/snapshots/a822eead8afcc5c3a096df96edcbbcf94f25b936
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-da/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-da/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-da/snapshots/a822eead8afcc5c3a096df96edcbbcf94f25b936
  cp -v tts_models--da--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-da/snapshots/a822eead8afcc5c3a096df96edcbbcf94f25b936
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-da/snapshots/a822eead8afcc5c3a096df96edcbbcf94f25b936/speaker_ids.json
fi

if [[ $name == "et-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-et/snapshots/af74edf2def51c17309262681d647fdbbf78a0c7
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-et/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-et/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-et/snapshots/af74edf2def51c17309262681d647fdbbf78a0c7
  cp -v tts_models--et--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-et/snapshots/af74edf2def51c17309262681d647fdbbf78a0c7
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-et/snapshots/af74edf2def51c17309262681d647fdbbf78a0c7/speaker_ids.json
fi

if [[ $name == "ga-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ga/snapshots/178a25580efa4fbc8c35143aa7a5cbf441732321
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ga/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ga/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ga/snapshots/178a25580efa4fbc8c35143aa7a5cbf441732321
  cp -v tts_models--ga--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ga/snapshots/178a25580efa4fbc8c35143aa7a5cbf441732321
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ga/snapshots/178a25580efa4fbc8c35143aa7a5cbf441732321/speaker_ids.json
fi

if [[ $name == "hr-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-hr/snapshots/7ba17c08ccf1b86f6730e7bd155994ae9b259ee5
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-hr/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-hr/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-hr/snapshots/7ba17c08ccf1b86f6730e7bd155994ae9b259ee5
  cp -v tts_models--hr--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-hr/snapshots/7ba17c08ccf1b86f6730e7bd155994ae9b259ee5
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-hr/snapshots/7ba17c08ccf1b86f6730e7bd155994ae9b259ee5/speaker_ids.json
fi

if [[ $name == "lt-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lt/snapshots/5c7b52856cd144a3a852e43c272c54030c824b68
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lt/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lt/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lt/snapshots/5c7b52856cd144a3a852e43c272c54030c824b68
  cp -v tts_models--lt--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lt/snapshots/5c7b52856cd144a3a852e43c272c54030c824b68
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lt/snapshots/5c7b52856cd144a3a852e43c272c54030c824b68/speaker_ids.json
fi

if [[ $name == "lv-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lv/snapshots/c7e9bbe9e7b929db814985579afd3cb4483e56ba
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lv/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lv/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lv/snapshots/c7e9bbe9e7b929db814985579afd3cb4483e56ba
  cp -v tts_models--lv--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lv/snapshots/c7e9bbe9e7b929db814985579afd3cb4483e56ba
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-lv/snapshots/c7e9bbe9e7b929db814985579afd3cb4483e56ba/speaker_ids.json
fi

if [[ $name == "mt-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-mt/snapshots/9e4bd666169645cfa4c9206728813627e28630b3
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-mt/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-mt/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-mt/snapshots/9e4bd666169645cfa4c9206728813627e28630b3
  cp -v tts_models--mt--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-mt/snapshots/9e4bd666169645cfa4c9206728813627e28630b3
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-mt/snapshots/9e4bd666169645cfa4c9206728813627e28630b3/speaker_ids.json
fi

if [[ $name == "pt-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-pt/snapshots/3a1261ab510baede428b523c490c9da8bb7663c1
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-pt/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-pt/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-pt/snapshots/3a1261ab510baede428b523c490c9da8bb7663c1
  cp -v tts_models--pt--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-pt/snapshots/3a1261ab510baede428b523c490c9da8bb7663c1
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-pt/snapshots/3a1261ab510baede428b523c490c9da8bb7663c1/speaker_ids.json
fi

if [[ $name == "ro-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ro/snapshots/b1f125a250cd74ccddab195817a2b8d977ed53cf
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ro/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ro/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ro/snapshots/b1f125a250cd74ccddab195817a2b8d977ed53cf
  cp -v tts_models--ro--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ro/snapshots/b1f125a250cd74ccddab195817a2b8d977ed53cf
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-ro/snapshots/b1f125a250cd74ccddab195817a2b8d977ed53cf/speaker_ids.json
fi

if [[ $name == "sk-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sk/snapshots/339546c562106429f3e7ef827080577c148ef51c
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sk/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sk/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sk/snapshots/339546c562106429f3e7ef827080577c148ef51c
  cp -v tts_models--sk--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sk/snapshots/339546c562106429f3e7ef827080577c148ef51c
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sk/snapshots/339546c562106429f3e7ef827080577c148ef51c/speaker_ids.json
fi

if [[ $name == "sl-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sl/snapshots/06d23d84fa3a982a9a109a2ca8bf48cbcc60fe72
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sl/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sl/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sl/snapshots/06d23d84fa3a982a9a109a2ca8bf48cbcc60fe72
  cp -v tts_models--sl--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sl/snapshots/06d23d84fa3a982a9a109a2ca8bf48cbcc60fe72
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sl/snapshots/06d23d84fa3a982a9a109a2ca8bf48cbcc60fe72/speaker_ids.json
fi

if [[ $name == "sv-cv" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sv/snapshots/16b05312ed40a891e1d6805f754b7a30c134031d
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sv/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sv/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sv/snapshots/16b05312ed40a891e1d6805f754b7a30c134031d
  cp -v tts_models--sv--cv--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sv/snapshots/16b05312ed40a891e1d6805f754b7a30c134031d
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-cv-sv/snapshots/16b05312ed40a891e1d6805f754b7a30c134031d/speaker_ids.json
fi

if [[ $name == "pl-mai_female" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-pl/snapshots/7013db9c212e26ce8d2de0a5c28a946d7a117ade
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-pl/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-pl/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-pl/snapshots/7013db9c212e26ce8d2de0a5c28a946d7a117ade
  cp -v tts_models--pl--mai_female--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-pl/snapshots/7013db9c212e26ce8d2de0a5c28a946d7a117ade
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-mai-pl/snapshots/7013db9c212e26ce8d2de0a5c28a946d7a117ade/speaker_ids.json
fi

if [[ $name == "es-css10" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-es/snapshots/098d86d7755ae33ce745743b97f7d0d7e4b271cd
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-es/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-es/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-es/snapshots/098d86d7755ae33ce745743b97f7d0d7e4b271cd
  cp -v tts_models--es--css10--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-es/snapshots/098d86d7755ae33ce745743b97f7d0d7e4b271cd
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-es/snapshots/098d86d7755ae33ce745743b97f7d0d7e4b271cd/speaker_ids.json
fi

if [[ $name == "fr-css10" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fr/snapshots/a3247f154d2fa5099bee23de35ba19907bc31b48
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fr/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fr/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fr/snapshots/a3247f154d2fa5099bee23de35ba19907bc31b48
  cp -v tts_models--fr--css10--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fr/snapshots/a3247f154d2fa5099bee23de35ba19907bc31b48
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fr/snapshots/a3247f154d2fa5099bee23de35ba19907bc31b48/speaker_ids.json
fi

if [[ $name == "nl-css10" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-nl/snapshots/be7a7c7bee463588626b10777d7fc14ed8c07a3e
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-nl/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-nl/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-nl/snapshots/be7a7c7bee463588626b10777d7fc14ed8c07a3e
  cp -v tts_models--nl--css10--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-nl/snapshots/be7a7c7bee463588626b10777d7fc14ed8c07a3e
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-nl/snapshots/be7a7c7bee463588626b10777d7fc14ed8c07a3e/speaker_ids.json
fi

if [[ $name == "de-css10" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-de/snapshots/9b3587ba721eebad881e3e261384ff6196f5fee1
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-de/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-de/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-de/snapshots/9b3587ba721eebad881e3e261384ff6196f5fee1
  cp -v tts_models--de--css10--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-de/snapshots/9b3587ba721eebad881e3e261384ff6196f5fee1
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-de/snapshots/9b3587ba721eebad881e3e261384ff6196f5fee1/speaker_ids.json
fi

if [[ $name == "hu-css10" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-hu/snapshots/e3fbd26f31b6ac49f6acd000c5e099cc57baa363
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-hu/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-hu/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-hu/snapshots/e3fbd26f31b6ac49f6acd000c5e099cc57baa363
  cp -v tts_models--hu--css10--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-hu/snapshots/e3fbd26f31b6ac49f6acd000c5e099cc57baa363
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-hu/snapshots/e3fbd26f31b6ac49f6acd000c5e099cc57baa363/speaker_ids.json
fi

if [[ $name == "fi-css10" ]]; then
  sudo mkdir -p /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fi/snapshots/528484f557830291d300ed23246621ed3c5f6e8d
  sudo chmod a=rwx /root/
  sudo chmod a=rwx /root/.cache/
  sudo chmod a=rwx /root/.cache/huggingface/
  sudo chmod a=rwx /root/.cache/huggingface/hub/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fi/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fi/snapshots/
  sudo chmod a=rwx /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fi/snapshots/528484f557830291d300ed23246621ed3c5f6e8d
  cp -v tts_models--fi--css10--vits/speaker_ids.json /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fi/snapshots/528484f557830291d300ed23246621ed3c5f6e8d
  sudo chmod a+r /root/.cache/huggingface/hub/models--neongeckocom--tts-vits-css10-fi/snapshots/528484f557830291d300ed23246621ed3c5f6e8d/speaker_ids.json
fi


pip install -q TTS onnx onnxruntime

python3 ./vits-coqui.py
ls -lh *.onnx
