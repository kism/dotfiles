#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

apps=(
    "CotEditor"
    "Hex Fiend"
    "Keka"
    "DaisyDisk"
    "Whisper Transcription"
    "Magnet"
    "Bitwarden"
    "WireGuard"
    "Picview"
    "iStat Menus 7"
    "Amphetamine"
    "Tailscale"
    "diskDedupe"
    # "Pages: Create Documents"
    # "Keynote: Design Presentations"
    # "Windows App"
)

echo "Installing apps from the App Store using mas"

for app in "${apps[@]}"; do
    echo
    echo "Installing $app"
    mas lucky "$app"
done

# ponytail: "mas lucky Krita" picks ibisPaint, so install by ID
mas install 1594607976 # Krita

echo
echo "Done"
