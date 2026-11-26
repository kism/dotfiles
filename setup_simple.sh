#!/usr/bin/env bash

# Download all the dotfiles
# Exit the script if there is an error
set -eo pipefail

BASE=${BASE:-https://raw.githubusercontent.com/kism/dotfiles/main} # CI points this at the checkout

get() {
    echo "Setting up $1..."
    mkdir -p "$(dirname ~/"$1")"
    curl --fail --silent -L "$BASE/$1" -o ~/"$1"
}

for f in .bashrc .bash_profile .bash_aliases .inputrc .tmux.conf .vimrc .config/nvim/init.lua \
    .config/htop/htoprc .config/btop/btop.conf .terminfo/g/ghostty .terminfo/x/xterm-ghostty \
    .local/bin/unarchive; do
    get "$f"
done
chmod +x ~/.local/bin/unarchive # curl drops the exec bit

echo "Setting up .zshrc..."
curl --fail --silent -L "$BASE/.zshrc" | sed '/^# simple:skip$/,/^# simple:end$/d' >~/.zshrc

if [ $EUID -eq 0 ]; then # If this is setting up the root user account, make the tmux bar red
    sed -i 's/green/red/g' ~/.tmux.conf
    sed -i 's/colour10/colour9/g' ~/.tmux.conf
fi

if [ "$1" == "--gui" ]; then
    get .config/ghostty/config.ghostty
fi
