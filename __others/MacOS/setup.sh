#!/usr/bin/env sh

# Don't write .DS_Store files on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

# Make holding characters behave normally
defaults write -g ApplePressAndHoldEnabled -bool false

if [ ! -d "/Applications/CotEditor.app" ]; then
    echo "CotEditor is not installed."
    echo "Please install CotEditor from the App Store / mas"
else
    echo "Adding cot to /usr/local/bin"
    ln -s /Applications/CotEditor.app/Contents/SharedSupport/bin/cot /usr/local/bin/cot
fi
