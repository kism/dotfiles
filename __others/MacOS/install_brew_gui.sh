#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

casks=(
    betterdisplay
    cyberduck
    ghostty
    secretive
    thaw@beta
    claude-code
    font-fira-code
    font-iosevka
    domzilla-caffeine
    obs
    audacity
    libreoffice
    foobar2000
    macshot-offline
    # shutter-encoder
    # porting-kit
    # ares-emulator
    # space-cadet-pinball
)

brew install --cask "${casks[@]}"
