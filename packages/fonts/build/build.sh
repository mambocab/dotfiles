#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

hash ttfautohint || brew install ttfautohint

if [[ ! -f ./Iosevka/package.json ]]; then
  rm -rf ./Iosevka
  git clone --depth 1 https://github.com/be5invis/Iosevka.git
fi

cp ./private-build-plans.toml ./Iosevka
(
  cd ./Iosevka
  npm install
  npm run build -- ttf::IosevkaMambocab --jCmd=4
)

dest="../Library/Fonts/IosevkaMambocab"
mkdir -p "$dest"
cp ./Iosevka/dist/IosevkaMambocab/TTF/*.ttf "$dest/"

brew uninstall ttfautohint || true
