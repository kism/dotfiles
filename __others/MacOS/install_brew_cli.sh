#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

formulae=(
    mas
    ffmpeg
    yt-dlp
    coreutils
    htop
    btop
    fastfetch
    cmatrix
    nload
    gh
    git-lfs
    uv
    pnpm
    nvm
    shfmt
    neovim
    tmux
    stow
    ncdu
    tree
    wget
    rename
    exiftool
    imagemagick
    mpv
    nmap
    # rdfind
    # go
    # hashicorp/tap/terraform
    # qemu
    # mame
    # fwupd
    # makeicns
)

brew install "${formulae[@]}"
