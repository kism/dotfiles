#!/usr/bin/env bash

# Dotfiles installer, requires bash, installs prereqs

baseinstall="zsh git htop tmux curl neofetch"

notpkginstall="vim"
pkginstall="vim-console"

dnfaptinstall="openssh-server"

function setup_brew() {
	baseinstall="$baseinstall $notpkginstall"
	h1 "Brew (MacOS Package Manager)"
	if ! which brew > /dev/null; then
		h2 "Installing Brew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	else
		h2 "Updating Brew"
		brew update
	fi
	
	h2 "Updating Brew Formulas"
	brew upgrade; checksuccess
	
	h2 "Installing Packages"
	echo
	brew install $baseinstall
}

function setup_pkg() {
	baseinstall="$baseinstall $pkginstall"
	prepsudo

	h2 "pkg update"
	yes | sudo pkg update
	h2 "pkg upgrade"
	yes | sudo pkg upgrade
	h2 "Installing Packages"
	yes | sudo pkg install $baseinstall

	h3 "Remember to set zsh as your default shell!"
}

function setup_pacman() {
	baseinstall="$baseinstall $notpkginstall"
	prepsudo

	h1 "Updating $PRETTY_NAME"
	h2 "pacman -Syyu"
	sudo pacman -Syyu --noconfirm
	h2 "Installing Packages"
	sudo pacman -S --noconfirm $baseinstall

	set_shell_chsh
}

function setup_apt() {
	baseinstall="$baseinstall $notpkginstall"
	prepsudo

	h1 "Updating $PRETTY_NAME"
	h2 "apt update"
	sudo apt-get update
	h2 "apt upgrade"
	sudo apt-get upgrade -y
	h2 "Installing Packages"
	sudo apt-get install --no-install-recommends -y $baseinstall $dnfaptinstall

	set_shell_chsh
}

function setup_dnf() {
	baseinstall="$baseinstall $notpkginstall"
	prepsudo

	h1 "Updating $PRETTY_NAME"
	h2 "dnf clean all"
	sudo dnf clean all
	h2 "dnf upgrade, install epel"
	sudo dnf upgrade
	sudo dnf install -y epel-release
	h2 "Installing Packages"
	sudo dnf --setopt=install_weak_deps=False --best install -y $baseinstall $dnfaptinstall
	
	set_shell_chsh
}

function set_shell_chsh() {
	echo
	if ! getent passwd $USER | cut -d : -f 7 | grep zsh > /dev/null; then
		h1 "Setting zsh as user's shell"
		h2 "Setting your default shell:"
		myshell=$(cat /etc/shells | grep -m 1 "zsh")
		chsh -s $myshell $USER
		checksuccess
	else
		echo "User $USER is already using zsh as their shell"
	fi
}

function prepsudo() {
	h3 "Installing packages will require sudo, checking if sudo is installed:"	
	type sudo > /dev/null 2> /dev/null; checksuccess "crit"
	sudo echo "Starting install!"; checksuccess "crit"
}

function checksuccess() {
	if [ $? -eq 0 ]; then
		echo -e "\033[0;32mSuccess!\033[0m"
	else
		if [ "$1" != "crit" ]; then
			echo -e "\033[0;31mFailure\033[0m" >&2
		else
			echo -e "\033[0;31mFailure, Exiting\033[0m" >&2
			exit 1
		fi
	fi
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

# Start
hr
h1 "Dotfiles Install!"

# Preflight checks
if [ $EUID -eq 0 ]; then
	echo "This script must not be run as root" 
	exit 1
fi

# Call function according to detected distro
h2 "Detecting OS:"
unameresult=`uname`

case $unameresult in 
	Darwin)
		echo "MacOS"
		setup_brew
	;;

	FreeBSD)
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

# BASH
h1 "Setting up bash"
h2 "Copying .bashrc"
if type bash > /dev/null; then
	cp _bash/.bashrc ~/.bashrc; checksuccess
else
	h3 "bash not found, wat?, skipping"
fi

# TMUX
if type tmux > /dev/null; then
	h1 "Setting up tmux"
	h2 "Copying .tmux.conf"
	cp _tmux/.tmux.conf ~/.tmux.conf; checksuccess
else
	h3 "tmux not found, skipping"
fi

# VIM
if type vim > /dev/null; then
	h1 "Setting up vim"
	h2 "Checking for Vundle:"
	vundlelocation=~/.vim/bundle/Vundle.vim
	if test -d $vundlelocation; then
		echo -e "Vundle Found!"
		git -C $vundlelocation pull --no-rebase; checksuccess
	else
		echo -e "Vundle Not Found!"
		git clone https://github.com/VundleVim/Vundle.vim.git $vundlelocation; checksuccess
	fi

	h2 "Copying .vimrc"
	cp _vim/.vimrc ~/.vimrc; checksuccess
	h2 "PluginInstall Starting"
	vim +PluginInstall +qall > /dev/null 2> /dev/null; checksuccess
else
	h3 "vim not found, skipping"
fi

#HTOP
if type htop > /dev/null; then
	h1 "Setting up htop"
	h2 "Copying htoprc"
	mkdir -p ~/.config/htop/
	cp -r _htop/.config ~ ; checksuccess
else
	echo -e "htop not found, skipping"
fi

# ZSH
if type vim > /dev/null; then
	h1 "Setting up zsh"
	antigenlocation=~/.antigen
	if ! test -d $antigenlocation; then
		h2 "Creating $antigenlocation"
		mkdir $antigenlocation; checksuccess
	fi
	h2 "Downloading Antigen:"
	curl -s -L git.io/antigen >~/.antigen/antigen.zsh; checksuccess

	h2 "Copying .zshrc"
	cp _zsh/.zshrc ~/.zshrc; checksuccess

	h2 "Updating Antigen Bundles:"
	zsh -c ". ~/.zshrc; antigen update; antigen reset"
else
	h3 "zsh not found, skipping"
fi

h3 "All done!"
hr
echo
