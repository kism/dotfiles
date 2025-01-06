#!/usr/bin/env bash

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
