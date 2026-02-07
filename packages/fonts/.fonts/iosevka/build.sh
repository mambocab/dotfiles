#! /usr/bin/env sh
set -eo pipefail

hash ttfautohint || brew install ttfautohint

# git clone --depth 1 git@github.com:be5invis/Iosevka.git
cp ./private-build-plans.toml ./Iosevka
(
  cd ./Iosevka
  npm install
  npm run build -- ttf::IosevkaMambocab --jCmd=1
)

brew uninstall ttfautohint || true
