#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit

set -e

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

# Mouse
defaults write -g com.apple.mouse.scaling 0.875                # Pointer speed
defaults write -g com.apple.mouse.linear 1                     # Acceleration
defaults write -g com.apple.swipescrolldirection -bool "false" # Natural scrolling direction off

# Keyboard
defaults write -g InitialKeyRepeat -int 25               # Key repeat
defaults write -g KeyRepeat -int 2                       # Key repeat
defaults write -g ApplePressAndHoldEnabled -bool "false" # Make holding characters behave normally
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool "false" # Disable double-space period

# Interface
defaults write -g AppleInterfaceStyle Dark # Dark mode
defaults write -g AppleShowScrollBars -string "WhenScrolling;" # Show scroll bars when scrolling

# Dock, Finder, Firefox, misc: config profiles in ./profiles (managed, so locked in System Settings)
# `profiles install` is dead since Big Sur, so open each and approve in System Settings > General > Device Management

# macOS only holds one pending profile at a time, so install them one by one
for profile in profiles/*.mobileconfig; do
    profile_id="$(basename "$profile" .mobileconfig)"
    # Same PayloadIdentifier replaces the installed profile, so reopen when the file hash changes
    # ponytail: stamp is written on Enter, it can't tell an approved update from an ignored one
    stamp="$HOME/.local/state/kism-dotfiles/$profile_id.sha256"
    hash="$(shasum -a 256 "$profile" | cut -d ' ' -f 1)"
    while ! { profiles list 2>/dev/null | grep -q "$profile_id" && [ "$(cat "$stamp" 2>/dev/null)" = "$hash" ]; }; do
        open "$profile"
        open "x-apple.systempreferences:com.apple.preferences.configurationprofiles"
        read -r -p "Approve $profile_id in System Settings, then press Enter (s to skip): " answer
        [ "$answer" = "s" ] && break
        profiles list 2>/dev/null | grep -q "$profile_id" && mkdir -p "${stamp%/*}" && echo "$hash" >"$stamp"
    done
done
echo "Log out and back in for the kism-dotfiles profiles to fully apply."

# Symlinks

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

COT_SYMLINK_PATH="$LOCAL_BIN/cot"

if [ -f "$COT_SYMLINK_PATH" ]; then
    echo "cot is already symlinked."
elif [ -d "/Applications/CotEditor.app" ]; then
    echo "Found CotEditor in /Applications"
    echo "Adding cot to $COT_SYMLINK_PATH"
    ln -s "/Applications/CotEditor.app/Contents/SharedSupport/bin/cot" "$COT_SYMLINK_PATH"
elif [ -d "$HOME/Applications/CotEditor.app" ]; then
    echo "Found CotEditor in $HOME/Applications"
    echo "Adding cot to $COT_SYMLINK_PATH"
    ln -s "$HOME/Applications/CotEditor.app/Contents/SharedSupport/bin/cot" "$COT_SYMLINK_PATH"
else
    echo "CotEditor is not installed."
    echo "Please install CotEditor from the App Store / mas"
fi
