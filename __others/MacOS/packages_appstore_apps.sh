#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

apps=(
    "CotEditor"
    "Hex Fiend"
    "The Unarchiver"
    "DaisyDisk"
    "Whisper Transcription"
    "Magnet"
    "Bitwarden"
    "WireGuard"
)

echo "Installing apps from the App Store using mas"

for app in "${apps[@]}"; do
    echo
    echo "Installing $app"
    mas lucky "$app"
done

echo
echo "Done"
