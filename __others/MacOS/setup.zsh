#!/usr/bin/env zsh
# shellcheck shell=bash # Technically incorrect but shellcheck doesn't support zsh, it works decent

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write -g ApplePressAndHoldEnabled -bool false

