#!/usr/bin/env sh

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

brew install mas ffmpeg yt-dlp coreutils htop fastfetch cmatrix nload
