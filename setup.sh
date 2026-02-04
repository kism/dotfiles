#!/usr/bin/env bash
# Dotfiles installer, requires bash or zsh, installs prereqs
# For KiSM's dotfiles specifically

# Turn on errors
set -e

install_base="zsh git git-lfs htop tmux curl wget tree ncdu stow"
install_apt_brew_dnf_pacman="neovim"
install_pkg="vim-console"
install_brew="htop tmux wget tree ncdu stow coreutils neovim"
install_apt="software-properties-common gnupg2"

function setup_brew() {
    install_base="$install_base $install_brew $install_apt_brew_dnf_pacman"
    h1 "Brew (MacOS Package Manager)"
    if ! which brew >/dev/null; then
        h2 "Installing Brew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        h2 "Updating Brew"
        brew update
    fi

    h2 "Updating Brew Formulas"
    brew upgrade

    h2 "Installing Packages"
    echo
    # shellcheck disable=SC2086 # Required here to split the package list
    brew install $install_brew
}

function setup_pkg() {
    to_install="$install_base $install_pkg"
    prep_sudo

    h2 "pkg update"
    yes | sudo pkg update
    h2 "pkg upgrade"
    yes | sudo pkg upgrade
    h2 "Installing Packages"
    # shellcheck disable=SC2086 # Required here to split the package list
    yes | sudo pkg install $to_install

    h3 "Remember to set zsh as your default shell!"
}

function setup_pacman() {
    to_install="$install_base $install_apt_brew_dnf_pacman"
    prep_sudo

    h1 "Updating $PRETTY_NAME"
    h2 "pacman -Syyu"
    sudo pacman -Syyu --noconfirm
    h2 "Installing Packages"
    # shellcheck disable=SC2086 # Required here to split the package list
    sudo pacman -S --noconfirm --needed $to_install

    set_shell
}

function setup_apt() {
    to_install="$install_base $install_apt_brew_dnf_pacman"
    prep_sudo

    h1 "Updating $PRETTY_NAME"
    h2 "apt update"
    sudo apt-get update
    # shellcheck disable=SC2086 # Required here to split the package list
    sudo apt-get install --no-install-recommends -y $install_apt
    h2 "add-apt-repository -y ppa:neovim-ppa/unstable"
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    h2 "apt upgrade"
    sudo apt-get upgrade -y
    h2 "Installing Packages"
    # shellcheck disable=SC2086 # Required here to split the package list
    sudo apt-get install --no-install-recommends -y $to_install

    set_shell
}

function setup_dnf() {
    to_install="$install_base $install_apt_brew_dnf_pacman"
    prep_sudo

    h1 "Updating $PRETTY_NAME"
    h2 "dnf clean all"
    sudo dnf clean all
    h2 "dnf upgrade"
    sudo dnf upgrade -y
    if [ "$ID" == "fedora" ] || [[ $NAME == *"fedora"* ]]; then
        h2 "Fedora based system detected, enabling rpmfusion repos"
        sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
    else
        h2 "Enabling EPEL repo"
        sudo dnf install -y epel-release
    fi

    h2 "Installing Packages"
    # shellcheck disable=SC2086 # Required here to split the package list
    sudo dnf --setopt=install_weak_deps=False --best install -y $to_install

    set_shell
}

function set_shell() {
    echo
    if ! getent passwd "$USER" | cut -d : -f 7 | grep zsh >/dev/null; then
        h1 "Setting zsh as user's shell"
        h2 "Setting your default shell:"
        myshell=$(grep -m 1 "zsh" /etc/shells)
        set +e
        if type chsh >/dev/null; then
            sudo chsh -s "$myshell" "$USER"
        else
            sudo usermod --shell "$myshell" "$USER"
        fi
        set -e
    else
        echo "User $USER is already using zsh as their shell"
    fi
}

function prep_sudo() {
    h3 "Installing packages will require sudo, checking if sudo is installed:"
    type sudo >/dev/null 2>/dev/null
    sudo echo "Starting install!"
}

function hr() {
    echo
    echo "  .--.      .--.      .--.      .--.      .--.      .--.      .--.      .--."
    echo ":::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\"
    echo "'      \`--'      \`--'      \`--'      \`--'      \`--'      \`--'      \`--'      \`"
}

function h1() {
    echo
    echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
    echo " $1"
    echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

function h2() {
    echo
    echo -e "\033[0;35m$1\033[0m"
}

function h3() {
    echo
    echo -e "$1"
}

# Set working dir
cd "$(dirname "$0")"

# Help
if [[ $1 == --help ]]; then
    echo Kieran\'s Dotfiles installer
    echo "bash setup.sh --allow-root         # If you want to allow this to setup on the root account"
    echo "bash setup.sh --no-package-install # Don't install packages with the package manager, useful for re-running"
    exit 0
fi

# Start
hr
h1 "Dotfiles Install!"

# Preflight checks
if [ $EUID -eq 0 ] && [[ $1 != --allow-root ]]; then
    echo "This script must not be run as root!"
    echo "Use --allow-root if you really want to risk these wild dotfiles"
    echo "being added to the root user of your stable system."
    exit 1
fi

# Call function according to detected distro
h2 "Detecting OS:"
unameresult=$(uname)

if [[ $1 != --no-package-install ]]; then
    case $unameresult in
    Darwin)
        echo "MacOS"
        setup_brew
        ;;

    FreeBSD)
        echo "$unameresult"
        setup_pkg
        ;;

    SunOS)
        echo "$unameresult"
        setup_pkg
        ;;
    Linux)
        # Source linux os info
        if test -f /etc/os-release; then
            # shellcheck disable=SC1091
            source /etc/os-release
            echo "$PRETTY_NAME"
        else
            echo "What Linux is this even?"
        fi

        if type pacman >/dev/null 2>/dev/null; then
            setup_pacman
        elif type apt >/dev/null 2>/dev/null; then
            setup_apt
        elif type dnf >/dev/null 2>/dev/null; then
            setup_dnf
        else
            echo "Unknown *Nix distro"
        fi
        ;;
    *)
        echo "What OS is this even?"
        exit 1
        ;;
    esac
fi

# Stow
h1 "Stowing dotfiles"
if type stow >/dev/null; then
    h2 "Stowing dotfiles"
    stow --no-folding --adopt --target="$HOME" --stow .
else
    h3 "stow not found, skipping"
fi

# ZSH
if type zsh >/dev/null; then
    h1 "Setting up zsh"
    echo "Will install zinit when you open a new shell"
else
    h3 "zsh not found, skipping"
fi

# Git
if type git >/dev/null; then
    h1 "Setting up git"
    #h2 "Email"
    if [ "$USER" = "kism" ]; then
        h2 "Setting email as username is kism"
        git config --global user.email "kieran.lost.the.game@gmail.com"
    fi
    h2 "Name"
    git config --global user.name "Kieran Gee"
    h2 "Credential Helper"
    git config --global credential.helper store
    h2 "Rebase setting"
    git config --global pull.rebase true
    h2 "CRLF"
    git config --global core.autocrlf false
    h2 "EOL LF"
    git config --global core.eol lf
    h2 "Editor: vim"
    git config --global core.editor vim
    h2 "New repo default branch name"
    git config --global init.defaultBranch main
    h2 "rerere"
    git config --global rerere.enabled true
    h2 "Global git ignore: ~/.gitignore_global"
    touch ~/.gitignore_global
    echo "" > ~/.gitignore_global
    echo .DS_Store >> ~/.gitignore_global
    echo .Trash-* >> ~/.gitignore_global
    echo .fseventsd >> ~/.gitignore_global
    echo .Spotlight-V100 >> ~/.gitignore_global
    echo Thumbs.db >> ~/.gitignore_global
    git config --global core.excludesfile ~/.gitignore_global
else
    h3 "git not found, skipping"
fi

# SSH, this just exists to ensure COLORTERM is set for ssh sessions
if type ssh >/dev/null; then
    mkdir -p ~/.ssh
    touch ~/.ssh/config
    if ! grep -q "COLORTERM" ~/.ssh/config; then
        h1 "Setting up ssh config for COLORTERM"
        {
            echo "Host *"
            echo "    SendEnv COLORTERM"
        } >>~/.ssh/config
    else
        h3 "ssh config already set up, skipping"
    fi
else
    h3 "ssh not found, skipping"
fi

h3 "All done!"
hr
echo
