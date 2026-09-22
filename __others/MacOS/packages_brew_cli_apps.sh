#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

formulae=(
    mas
    ffmpeg
    yt-dlp
    coreutils
    htop
    fastfetch
    cmatrix
    nload
)

brew install "${formulae[@]}"
