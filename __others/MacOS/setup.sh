#!/usr/bin/env bash

# Don't write .DS_Store files on network drives, external drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool TRUE

# Mouse
defaults write -g com.apple.mouse.scaling -1 @ # Acceleration
defaults write -g com.apple.mouse.linear 1 # Acceleration
defaults write -g com.apple.swipescrolldirection -bool FALSE # Natural scrolling

# Keyboard
defaults write -g InitialKeyRepeat -int 25 # Key repeat
defaults write -g KeyRepeat -int 2 # Key repeat
defaults write -g ApplePressAndHoldEnabled -bool TRUE # Make holding characters behave normally

# Interface
defaults write -g AppleInterfaceStyle Dark # Dark mode


if [ ! -d "/Applications/CotEditor.app" ]; then
    echo "CotEditor is not installed."
    echo "Please install CotEditor from the App Store / mas"
else
    echo "Adding cot to /usr/local/bin"
    ln -s /Applications/CotEditor.app/Contents/SharedSupport/bin/cot /usr/local/bin/cot
fi
