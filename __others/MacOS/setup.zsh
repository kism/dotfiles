#!/usr/bin/env zsh
# shellcheck shell=bash # Technically incorrect but shellcheck doesn't support zsh

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
