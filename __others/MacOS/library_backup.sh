mkdir -p Library/Application\ Support

APP_NAME="com.nuebling.mac-mouse-fix"
mkdir -p Library/Application\ Support/$APP_NAME
defaults export $HOME/Library/Application\ Support/$APP_NAME/config.plist - > Library/Application\ Support/$APP_NAME/config.plist

# APP_NAME="com.jordanbaird.Ice"
# mkdir -p Library/Preferences/$APP_NAME
# defaults export $HOME/Library/Preferences/$APP_NAME.plist - > Library/Preferences/$APP_NAME.plist


