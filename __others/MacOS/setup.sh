#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

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
defaults write com.apple.dock "show-recent-count" -int "1"        # Show only one recent app, zero doesn't work
killall Dock

# Mission Control / Expose / Space
defaults write com.apple.dock "mru-spaces" -bool "true"        # Automatically rearrange spaces based on most recent use
defaults write com.apple.dock "expose-group-apps" -bool "true" # Group windows by application

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"             # Show all file extensions
defaults write com.apple.finder "ShowPathbar" -bool "true"                      # Show path bar
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"           # Use list view in all Finder windows
defaults write com.apple.finder "FXPreferredSearchViewStyle" -string "Nlsv"     # Use list view for search
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"              # Keep folders on top when sorting by name
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"           # Search the current folder by default
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"            # Remove items from the Trash after 30 days
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false" # Save to disk by default
killall Finder

# Menu Bar
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm\"" # Show date and time in the menu bar

# TextEdit
defaults write com.apple.TextEdit "RichText" -bool "false"

# Firefox Policies https://github.com/mozilla/policy-templates/blob/master/mac/org.mozilla.firefox.plist
defaults write org.mozilla.firefox "EnterprisePoliciesEnabled" -bool "true"
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

## Firefox Extensions
plutil -replace Extensions -dictionary ~/Library/Preferences/org.mozilla.firefox.plist
plutil -insert Extensions.Install -array ~/Library/Preferences/org.mozilla.firefox.plist
plutil -insert Extensions.Install.0 -string "https://addons.mozilla.org/firefox/downloads/file/4407804/bitwarden_password_manager-latest.xpi" ~/Library/Preferences/org.mozilla.firefox.plist
plutil -insert Extensions.Install.1 -string "https://addons.mozilla.org/firefox/downloads/file/4391011/ublock_origin-latest.xpi" ~/Library/Preferences/org.mozilla.firefox.plist
plutil -insert Extensions.Install.2 -string "https://addons.mozilla.org/firefox/downloads/file/3938344/scroll_anywhere-latest.xpi" ~/Library/Preferences/org.mozilla.firefox.plist

# Edge Policies https://github.com/TommyTran732/Microsoft-Edge-Policies/blob/main/macOS/Managed%20Preferences/com.microsoft.Edge.plist
## Search
defaults write com.microsoft.Edge "DefaultSearchProviderEnabled" -bool "true"
defaults write com.microsoft.Edge "DefaultSearchProviderName" -string "Google"
defaults write com.microsoft.Edge "DefaultSearchProviderSearchURL" -string "{google:baseURL}search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}ie={inputEncoding}'"
# defaults write com.microsoft.Edge "DefaultSearchProviderSuggestURL" -string "https://www.google.com/complete/search\?output\=toolbar\&q\=\{searchTerms\}"
defaults write com.microsoft.Edge "DefaultSearchProviderIconURL" -string "https://www.google.com/favicon.ico"

# Password Manager
defaults write com.microsoft.Edge "PasswordManagerEnabled" -bool "false"

# Gross Microsoft stuff
defaults write com.microsoft.Edge "WalletDonationEnabled" -bool "false"
defaults write com.microsoft.Edge "EdgeWalletCheckoutEnabled" -bool "false"
defaults write com.microsoft.Edge "EdgeWalletEtreeEnabled" -bool "false"
defaults write com.microsoft.Edge "ShowMicrosoftRewards" -bool "false"
defaults write com.microsoft.Edge "EdgeShoppingAssistantEnabled" -bool "false"

# Symlinks

if [ -f "/usr/local/bin/cot" ]; then
    echo "cot is already symlinked."
elif [ -d "/Applications/CotEditor.app" ]; then
    echo "Found CotEditor in /Applications"
    echo "Adding cot to /usr/local/bin"
    sudo ln -s /Applications/CotEditor.app/Contents/SharedSupport/bin/cot /usr/local/bin/cot
elif [ -d "$HOME/Applications/CotEditor.app" ]; then
    echo "Found CotEditor in $HOME/Applications"
    echo "Adding cot to /usr/local/bin"
    sudo ln -s "$HOME/Applications/CotEditor.app/Contents/SharedSupport/bin/cot" /usr/local/bin/cot
else
    echo "CotEditor is not installed."
    echo "Please install CotEditor from the App Store / mas"
fi
