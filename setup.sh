#!/bin/bash

baseinstall="vim zsh git htop tmux openssh-server curl" 

function setup_manjaro {
	hheader "Updating Manjaro"
	echo
	sudo pacman -Syyu
	hheader "Installing Packages"
	echo
	sudo pacman -Sy $baseinstall
	set_shell_chsh
}

function setup_ubuntu {
	hheader "Updating Ubuntu"
	echo
	sudo apt update
	sudo apt upgrade -y
	hheader "Installing Packages"
	echo
	sudo apt install -y $baseinstall
	set_shell_chsh
}

function setup_centos {
	hheader "Updating CentOS"
	echo
	sudo dnf clean all
	sudo dnf update
	sudo dnf install -y epel-release
	hheader "Installing Packages"
	echo
	sudo dnf install -y $baseinstall
}

function set_shell_chsh {
	echo
	hheader "Setting zsh as user shell"
	header "Setting your default shell:"
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

function hsep {
	echo
	echo "  .--.      .--.      .--.      .--.      .--.      .--.      .--.      .--."
	echo ":::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\"
	echo "'      \`--'      \`--'      \`--'      \`--'      \`--'      \`--'      \`--'      \`"
}

function hheader () {
	echo
	echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
	echo " $1"
	echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

function header () {
	echo
	echo -e "\033[0;35m$1\033[0m"
}

hsep

hheader "Dotfiles Install!"

# Start
echo -e "\nInstalling packages will require sudo"
sudo echo "Starting install!"

if [ $? -ne 0 ]; then
  echo "sudo failed" >&2
  exit 1
fi

# Call function according to detected distro
header "Detecting OS:"
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
hheader "Setting up bash"
header "Copying .bashrc"
cp _bash/.bashrc ~/.bashrc; checksuccess

# TMUX
hheader "Setting up tmux"
header "Copying .tmux.conf"
cp _tmux/.tmux.conf ~/.tmux.conf; checksuccess

# VIM
hheader "Setting up vim"
header "Checking for Vundle:"
vundlelocation=~/.vim/bundle/Vundle.vim
if test -d $vundlelocation; then
	echo -e "Vundle Found!"
    git -C $vundlelocation pull
else
	echo -e "Vundle Not Found!"
	git clone https://github.com/VundleVim/Vundle.vim.git $vundlelocation
fi
checksuccess
header "Copying .vimrc"
cp _vim/.vimrc ~/.vimrc; checksuccess

echo -e "\nRemember to run :PluginInstall"

# ZSH
hheader "Setting up zsh"
antigenlocation=~/.antigen
if ! test -d $antigenlocation; then
	echo "Creating $antigenlocation"
	mkdir $antigenlocation; checksuccess
fi
header "Downloading Antigen:"
curl -L git.io/antigen > ~/.antigen/antigen.zsh; checksuccess

header "Copying .vimrc"
cp _zsh/.zshrc ~/.zshrc; checksuccess

echo -e "\nAll done!"
hsep
echo