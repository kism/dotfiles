#!/usr/bin/env sh

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

brew install mas # Mac App Store CLI
brew install ffmpeg
brew install yt-dlp
brew install coreutils
brew install htop
brew install fastfetch
brew install cmatrix
