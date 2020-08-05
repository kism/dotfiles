#!/bin/bash

baseinstall="vim zsh git htop tmux openssh-server curl" 

function setup_manjaro {
	h1 "Updating Manjaro"
	echo
	sudo pacman -Syyu --noconfirm
	h1 "Installing Packages"
	echo
	sudo pacman -Sy --noconfirm $baseinstall
	set_shell_chsh
}

function setup_ubuntu {
	h1 "Updating Ubuntu"
	echo
	sudo apt update
	sudo apt upgrade -y
	h1 "Installing Packages"
	echo
	sudo apt install -y $baseinstall
	set_shell_chsh
}

function setup_centos {
	h1 "Updating CentOS"
	echo
	sudo dnf clean all
	sudo dnf update
	sudo dnf install -y epel-release
	h1 "Installing Packages"
	echo
	sudo dnf install -y $baseinstall
	set_shell_chsh
}

function set_shell_chsh {
	echo
	h1 "Setting zsh as user's shell"
	h2 "Setting your default shell:"
	myshell=$(which zsh)
	chsh -s $myshell $USER; checksuccess
}

function checksuccess {
	if [ $? -eq 0 ]; then
  		echo -e "\033[0;32mSuccess!\033[0m"
	else
  		echo -e "\033[0;31mFailure\033[0m" >&2
	fi
}

function hr {
	echo
	echo "  .--.      .--.      .--.      .--.      .--.      .--.      .--.      .--."
	echo ":::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\"
	echo "'      \`--'      \`--'      \`--'      \`--'      \`--'      \`--'      \`--'      \`"
}

function h1 () {
	echo
	echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
	echo " $1"
	echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

function h2 () {
	echo
	echo -e "\033[0;35m$1\033[0m"
}

function h3 () {
	echo
	echo -e "$1"
}

# Set working dir
cd "$(dirname "$0")"

# Start
hr
h1 "Dotfiles Install!"

echo -e "\nInstalling packages will require sudo"
sudo echo "Starting install!"

if [ $? -ne 0 ]; then
  echo "sudo failed" >&2
  exit 1
fi

# Call function according to detected distro
h2 "Detecting OS:"
if grep Manjaro /etc/os-release; then
	setup_manjaro
elif grep Ubuntu /etc/os-release; then
	setup_ubuntu
elif grep CentOS /etc/os-release; then
	setup_centos
else
	echo "Unknown *Nix distro"
	echo "Install tmux, vim and zsh"
fi

# BASH
h1 "Setting up bash"
h2 "Copying .bashrc"
cp _bash/.bashrc ~/.bashrc; checksuccess

# TMUX
h1 "Setting up tmux"
h2 "Copying .tmux.conf"
cp _tmux/.tmux.conf ~/.tmux.conf; checksuccess

# VIM
h1 "Setting up vim"
h2 "Checking for Vundle:"
vundlelocation=~/.vim/bundle/Vundle.vim
if test -d $vundlelocation; then
	echo -e "Vundle Found!"
	git -C $vundlelocation pull --no-rebase
else
	echo -e "Vundle Not Found!"
	git clone https://github.com/VundleVim/Vundle.vim.git $vundlelocation
fi
checksuccess
h2 "Copying .vimrc"
cp _vim/.vimrc ~/.vimrc; checksuccess

h3 "Remember to run :PluginInstall"

# ZSH
h1 "Setting up zsh"
antigenlocation=~/.antigen
if ! test -d $antigenlocation; then
	echo "Creating $antigenlocation"
	mkdir $antigenlocation; checksuccess
fi
h2 "Downloading Antigen:"
curl -L git.io/antigen > ~/.antigen/antigen.zsh; checksuccess

h2 "Copying .vimrc"
cp _zsh/.zshrc ~/.zshrc; checksuccess

h3 "All done!"
hr
echo
