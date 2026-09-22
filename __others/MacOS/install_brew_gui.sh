#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

formulae=(
    secretive
    thaw@beta
)

casks=(
    betterdisplay
    cyberduck
    ghostty
    finetune
)

brew install "${formulae[@]}"
brew install --cask "${casks[@]}"
