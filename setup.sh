#!/usr/bin/env bash
# Dotfiles installer, requires bash or zsh, installs prereqs
# For KiSM's dotfiles specifically

# Turn on errors
set -e

install_base="zsh git htop tmux curl wget neofetch keychain tree ncdu"
install_apt_brew_dnf="vim"
install_apt_brew_dnf_pacman="neovim"
install_apt_dnf="openssh-server"
install_pkg="vim-console"
install_brew="coreutils"

function setup_brew() {
    install_base="$install_base $install_apt_brew_dnf $install_brew $install_apt_brew_dnf_pacman"
    h1 "Brew (MacOS Package Manager)"
    if ! which brew > /dev/null; then
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
    brew install $install_base
}

function setup_pkg() {
    to_install="$install_base $install_pkg"
    prepsudo

    h2 "pkg update"
    yes | sudo pkg update
    h2 "pkg upgrade"
    yes | sudo pkg upgrade
    h2 "Installing Packages"
    yes | sudo pkg install $to_install

    h3 "Remember to set zsh as your default shell!"
}

function setup_pacman() {
    to_install="$install_base $install_apt_brew_dnf_pacman"
    prepsudo

    h1 "Updating $PRETTY_NAME"
    h2 "pacman -Syyu"
    sudo pacman -Syyu --noconfirm
    h2 "Installing Packages"
    sudo pacman -S --noconfirm $to_install

    set_shell_chsh
}

function setup_apt() {
    to_install="$install_base $install_apt_brew_dnf $install_apt_dnf $install_apt_brew_dnf_pacman"
    prepsudo

    h1 "Updating $PRETTY_NAME"
    h2 "apt update"
    sudo apt-get update
    h2 "add-apt-repository -y ppa:neovim-ppa/stable"
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    h2 "apt upgrade"
    sudo apt-get upgrade -y
    h2 "Installing Packages"
    sudo apt-get install --no-install-recommends -y $to_install

    set_shell_chsh
}

function setup_dnf() {
    to_install="$install_base $install_apt_brew_dnf $install_apt_dnf $install_apt_brew_dnf_pacman"
    prepsudo

    h1 "Updating $PRETTY_NAME"
    h2 "dnf clean all"
    sudo dnf clean all
    h2 "dnf upgrade, install epel"
    sudo dnf upgrade -y
    sudo dnf install -y epel-release
    h2 "Installing Packages"
    sudo dnf --setopt=install_weak_deps=False --best install -y $to_install

    set_shell_chsh
}

function set_shell_chsh() {
    echo
    if ! getent passwd $USER | cut -d : -f 7 | grep zsh > /dev/null; then
        h1 "Setting zsh as user's shell"
        h2 "Setting your default shell:"
        myshell=$(cat /etc/shells | grep -m 1 "zsh")
        sudo chsh -s $myshell $USER

    else
        echo "User $USER is already using zsh as their shell"
    fi
}

function prepsudo() {
    h3 "Installing packages will require sudo, checking if sudo is installed:"
    type sudo > /dev/null 2> /dev/null
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
if [[ $1 == --help ]] ; then
    echo Kieran\'s Dotfiles installer
    echo bash setup.sh --allow-root \# If you want to allow this to setup on the root account
    echo bash setup.sh --no-install \# Don\'t install packages with the package manager, useful for re-running
    exit 0
fi

# Start
hr
h1 "Dotfiles Install!"

# Preflight checks
if [ $EUID -eq 0 ] && [[ $1 != --allow-root ]] ; then
    echo "This script must not be run as root!"
    echo "Use --allow-root if you really want to risk these wild dotfiles"
    echo "being added to the root user of your stable system."
    exit 1
fi

# Call function according to detected distro
h2 "Detecting OS:"
unameresult=`uname`

if [[ $1 != --no-install ]] ; then
    case $unameresult in
        Darwin)
            echo "MacOS"
            setup_brew
        ;;

        FreeBSD)
            echo $unameresult
            setup_pkg
        ;;

        SunOS)
            echo $unameresult
            setup_pkg
        ;;
        Linux)
            # Source linux os info
            if test -f /etc/os-release; then
                . /etc/os-release
                echo $PRETTY_NAME
            else
                echo "What Linux is this even?"
            fi

            if type pacman > /dev/null 2> /dev/null; then
                setup_pacman
            elif type apt  > /dev/null 2> /dev/null; then
                setup_apt
            elif type dnf  > /dev/null 2> /dev/null; then
                setup_dnf
            else
                echo "Unknown *Nix distro"
            fi
        ;;
        *)
            echo "What OS is this even?"
            exit 1
    esac
fi

# BASH
curl --silent https://raw.githubusercontent.com/kism/dotfiles-simple/master/.bash_profile > .bash_profile
curl --silent https://raw.githubusercontent.com/kism/dotfiles-simple/master/.bashrc > .bashrc
curl --silent https://raw.githubusercontent.com/kism/dotfiles-simple/master/.inputrc > .inputrc

# ZSH
if type zsh > /dev/null; then
    h1 "Setting up zsh"
    antigenlocation=~/.antigen
    if ! test -d $antigenlocation; then
        h2 "Creating $antigenlocation"
        mkdir $antigenlocation
    fi
    h2 "Downloading Antigen:"
    curl -s -L https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh >~/.antigen/antigen.zsh

    h2 "Copying .zshrc"
    cp _zsh/.zshrc ~/.zshrc

    h2 "Updating Antigen Bundles:"
    zsh -c ". ~/.zshrc; antigen update; antigen reset"
else
    h3 "zsh not found, skipping"
fi

# TMUX
if type tmux > /dev/null; then
    h1 "Setting up tmux"
    h2 "Copying .tmux.conf"
    cp _tmux/.tmux.conf ~/.tmux.conf
else
    h3 "tmux not found, skipping"
fi

# VIM
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles-simple/master/.vimrc > ~/.vimrc

# NEOVIM
if type nvim > /dev/null; then
    h1 "Setting up neovim"
    h2 "Installing Plug:"
    curl -s -fLo ~/.local/share/nvim/site/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim --create-dirs
    nvim --headless +PlugInstall +qa
    h2 "Copying neovim config:"
    cp -r _nvim/.config ~
    h2 "Running neovim PlugInstall:"
    nvim --headless +PlugInstall +qa
    cp -r _nvim/.local ~
else
    echo "no nvim"
fi

# HTOP
mkdir -p ~/.config/htop/
curl --silent https://raw.githubusercontent.com/kism/dotfiles-simple/master/htoprc > ~/.config/htop/htoprc

# SSH
if [ "$USER" = "kism" ]; then
    if type ssh > /dev/null; then
        h1 "Setting up ssh"
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        if [ ! -f "$HOME/.ssh/config" ]; then
            h2 "Copying .ssh/config"
            cp _ssh/config ~/.ssh/config
        else
            echo -e "ssh config file found, not copying"
        fi
    else
        echo -e "ssh not found, skipping"
    fi
fi

# Git
if type git > /dev/null; then
    h1 "Setting up git"
    #h2 "Email"
    if [ "$USER" = "kism" ]; then
        h2 "Setting email as username is kism"
        git config --global user.email "kieran.lost.the.game@gmail.com"
    fi
    h2 "Credential Helper"
    git config --global credential.helper store
    h2 "Name"
    git config --global user.name "Kieran Gee"
    h2 "Rebase setting"
    git config --global pull.rebase true
    h2 CLRF""
    git config --global core.autocrlf false
    h2 "EOL LF"
    git config --global core.eol lf
    h2 "Editor: vim"
    git config --global core.editor vim
else
    h3 "ssh not found, skipping"
fi

h3 "All done!"
hr
echo
