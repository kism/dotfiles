#!/usr/bin/env bash

# Don't write .DS_Store files on network drives, external drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"

# Mouse
defaults write -g com.apple.mouse.scaling 0.875              # Pointer speed
defaults write -g com.apple.mouse.linear 1                   # Acceleration
defaults write -g com.apple.swipescrolldirection -bool FALSE # Natural scrolling

# Keyboard
defaults write -g InitialKeyRepeat -int 25              # Key repeat
defaults write -g KeyRepeat -int 2                      # Key repeat
defaults write -g ApplePressAndHoldEnabled -bool "true" # Make holding characters behave normally

# Interface
defaults write -g AppleInterfaceStyle Dark              # Dark mode

# Dock
defaults write com.apple.dock "orientation" -string "left" && killall Dock               # Dock position
defaults write com.apple.dock "tilesize" -int "46" && killall Dock                       # Set Dock icon size
defaults write com.apple.dock "autohide-delay" -float "0" && killall Dock                # Remove Dock show/hide delay
defaults write com.apple.dock "autohide-time-modifier" -float "0" && killall Dock        # Remove Dock show/hide animation
defaults write com.apple.dock "mineffect" -string "scale" && killall Dock                # Scale effect

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true" && killall Finder    # Show all file extensions
defaults write com.apple.finder "ShowPathbar" -bool "true" && killall Finder             # Show path bar
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" && killall Finder  # Use list view in all Finder windows
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true" && killall Finder     # Keep folders on top when sorting by name
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf" && killall Finder  # Search the current folder by default
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true" && killall Finder   # Remove items from the Trash after 30 days
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"          # Save to disk by default

# Menu Bar
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm\""      # Show date and time in the menu bar

# TextEdit
defaults write com.apple.TextEdit "RichText" -bool "false" && killall TextEdit            # Use plain text mode by default

if [ ! -d "/Applications/CotEditor.app" ]; then
    echo "CotEditor is not installed."
    echo "Please install CotEditor from the App Store / mas"
else
    echo "Adding cot to /usr/local/bin"
    sudo ln -s /Applications/CotEditor.app/Contents/SharedSupport/bin/cot /usr/local/bin/cot
fi
