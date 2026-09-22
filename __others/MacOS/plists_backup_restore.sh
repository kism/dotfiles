#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

if [ "$1" != "backup" ] && [ "$1" != "restore" ]; then
  echo "Usage: $0 [backup|restore]"
  exit 1
fi

# Set working dir
cd "$(dirname "$0")" || exit

plists=(
  "Application Support/com.nuebling.mac-mouse-fix/config.plist"
  "Preferences/com.crowdcafe.windowmagnet.plist"
)

for plist in "${plists[@]}"; do
  echo "$1 $plist"
  if [ "$1" == "backup" ]; then
    mkdir -p "Library/$(dirname "$plist")"
    defaults export "$HOME/Library/$plist" - >"Library/$plist"
  else
    defaults import "$HOME/Library/$plist" "Library/$plist"
  fi
done
