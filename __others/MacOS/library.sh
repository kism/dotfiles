#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 [backup|restore]"
  echo "No arguments provided. Exiting."
  exit 1
fi

if [ "$1" != "backup" ] && [ "$1" != "restore" ]; then
  echo "Invalid argument. Only 'backup' or 'restore' are allowed. Exiting."
  exit 1
fi

# Section, Application Support
mkdir -p Library/Application\ Support

# Section, mac-mouse-fix
APP_NAME="com.nuebling.mac-mouse-fix"
if [ "$1" == "backup" ]; then
  echo "$1 $APP_NAME"
  mkdir -p Library/Application\ Support/$APP_NAME
  defaults export $HOME/Library/Application\ Support/$APP_NAME/config.plist - >Library/Application\ Support/$APP_NAME/config.plist
else
  echo "$1 $APP_NAME"
  defaults import $HOME/Library/Application\ Support/$APP_NAME/config.plist Library/Application\ Support/$APP_NAME/config.plist
fi
