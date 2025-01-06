mkdir -p Library/Application\ Support

APP_NAME="com.nuebling.mac-mouse-fix"
mkdir -p Library/Application\ Support/$APP_NAME
defaults export $HOME/Library/Application\ Support/$APP_NAME/config.plist - > Library/Application\ Support/$APP_NAME/config.plist



