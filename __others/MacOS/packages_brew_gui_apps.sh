#!/usr/bin/env sh

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

brew install --cask betterdisplay
brew install --cask domzilla-caffeine
brew install --cask cyberduck
brew install --cask easy-move-plus-resize
brew install stats
brew install secretive
brew install jordanbaird-ice
brew install --cask ghostty


