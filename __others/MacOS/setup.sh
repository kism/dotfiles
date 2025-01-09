#!/usr/bin/env bash

# Don't write .DS_Store files on network drives, external drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"

# Mouse
defaults write -g com.apple.mouse.scaling 0.875                # Pointer speed
defaults write -g com.apple.mouse.linear 1                     # Acceleration
defaults write -g com.apple.swipescrolldirection -bool "false" # Natural scrolling direction off

# Keyboard
defaults write -g InitialKeyRepeat -int 25               # Key repeat
defaults write -g KeyRepeat -int 2                       # Key repeat
defaults write -g ApplePressAndHoldEnabled -bool "false" # Make holding characters behave normally

# Interface
defaults write -g AppleInterfaceStyle Dark # Dark mode

# Dock
defaults write com.apple.dock "orientation" -string "left"        # Dock position
defaults write com.apple.dock "tilesize" -int "46"                # Set Dock icon size
defaults write com.apple.dock "autohide-delay" -float "0"         # Remove Dock show/hide delay
defaults write com.apple.dock "autohide-time-modifier" -float "0" # Remove Dock show/hide animation
defaults write com.apple.dock "mineffect" -string "scale"         # Scale effect
defaults write com.apple.dock "show-recents" -bool "true"         # Enable show recent apps (Just for the divider)
defaults write com.apple.dock "show-recent-count" -int "0"        # Show no recent apps
killall Dock

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"             # Show all file extensions
defaults write com.apple.finder "ShowPathbar" -bool "true"                      # Show path bar
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"           # Use list view in all Finder windows
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"              # Keep folders on top when sorting by name
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"           # Search the current folder by default
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"            # Remove items from the Trash after 30 days
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false" # Save to disk by default
killall Finder

# Menu Bar
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm\"" # Show date and time in the menu bar

# TextEdit
defaults write com.apple.TextEdit "RichText" -bool "false" && killall TextEdit # Use plain text mode by default

# Firefox Policies https://github.com/mozilla/policy-templates/blob/master/mac/org.mozilla.firefox.plist
defaults write org.mozilla.firefox "DisablePocket" -bool "true"
defaults write org.mozilla.firefox "PasswordManagerEnabled" -bool "false"
defaults write org.mozilla.firefox "NoDefaultBookmarks" -bool "true"
defaults write org.mozilla.firefox "FirefoxHome" -dict \
    Search -bool "true" \
    TopSites -bool "false" \
    SponsoredTopSites -bool "false" \
    Highlights -bool "false" \
    Pocket -bool "false" \
    SponsoredPocket -bool "false" \
    WebSuggestions -bool "false" \
    SponsoredSuggestions -bool "false" \
    ImproveSuggest -bool "false" \
    Locked -bool "false"

# Edge Policies https://github.com/TommyTran732/Microsoft-Edge-Policies/blob/main/macOS/Managed%20Preferences/com.microsoft.Edge.plist
defaults write com.microsoft.Edge "DefaultSearchProviderEnabled" -bool "true"
defaults write com.microsoft.Edge "DefaultSearchProviderName" -string "Google"
defaults write com.microsoft.Edge "DefaultSearchProviderSearchURL" -string "https://www.google.com/search\?q\=\{searchTerms\}"
defaults write com.microsoft.Edge "DefaultSearchProviderSuggestURL" -string "https://www.google.com/complete/search\?output\=toolbar\&q\=\{searchTerms\}"
defaults write com.microsoft.Edge "DefaultSearchProviderIconURL" -string "https://www.google.com/favicon.ico"

defaults write com.microsoft.Edge "PasswordManagerEnabled" -bool "false"

defaults write com.microsoft.Edge "WalletDonationEnabled" -bool "false"
defaults write com.microsoft.Edge "EdgeWalletCheckoutEnabled" -bool "false"
defaults write com.microsoft.Edge "EdgeWalletEtreeEnabled" -bool "false"
defaults write com.microsoft.Edge "ShowMicrosoftRewards" -bool "false"
defaults write com.microsoft.Edge "EdgeShoppingAssistantEnabled" -bool "false"

# Symlinks

if [ ! -d "/Applications/CotEditor.app" ]; then
    echo "CotEditor is not installed."
    echo "Please install CotEditor from the App Store / mas"
else
    echo "Adding cot to /usr/local/bin"
    sudo ln -s /Applications/CotEditor.app/Contents/SharedSupport/bin/cot /usr/local/bin/cot
fi
