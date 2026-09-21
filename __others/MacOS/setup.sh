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
# Remove the old defaults-written copies of these so only the profiles set them
unset_keys() {
    domain="$1"
    shift
    for key in "$@"; do
        defaults delete "$domain" "$key" 2>/dev/null || true
    done
}
unset_keys com.apple.desktopservices DSDontWriteNetworkStores DSDontWriteUSBStores
unset_keys com.apple.dock orientation tilesize autohide-delay autohide-time-modifier mineffect show-recents \
    show-recent-count springboard-columns springboard-rows scroll-to-open mru-spaces expose-group-apps
unset_keys com.apple.finder ShowPathbar FXPreferredViewStyle FXPreferredSearchViewStyle _FXSortFoldersFirst \
    FXDefaultSearchScope FXRemoveOldTrashItems
unset_keys -g AppleShowAllExtensions NSDocumentSaveNewDocumentsToCloud
unset_keys com.apple.menuextra.clock DateFormat
unset_keys com.apple.TextEdit RichText
defaults delete org.mozilla.firefox 2>/dev/null || true # Only ever held our policies

for profile in profiles/*.mobileconfig; do
    open "$profile"
done
echo "Approve the kism-dotfiles profiles in System Settings, then log out and back in."

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

# Remove old detectdisplays scheduled task
set +e
launchctl bootout "gui/$(id -u)/au.kierangee.detectdisplays" 2>/dev/null
set -e
rm -f "$HOME/Library/LaunchAgents/au.kierangee.detectdisplays.plist"
sudo rm -f "/usr/local/bin/detectdisplays.applescript"
