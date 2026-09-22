#!/usr/bin/env sh

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

brew install secretive thaw@beta
brew install --cask betterdisplay cyberduck ghostty finetune
