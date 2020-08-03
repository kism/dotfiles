#!/bin/bash

baseinstall="vim zsh git htop tmux openssh-server curl" 

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

function setup_manjaro {
	hsep
	pacman -Syyu
	pacman -Sy $baseinstall
	set_shell_chsh
}

function setup_ubuntu {
	hsep
	apt update
	apt upgrade
	apt install -y $baseinstall
	set_shell_chsh
}

function setup_centos {
	hsep
	yum clean all
	yum update
	yum install -y epel-release
	yum install -y $baseinstall
}

function set_shell_chsh {
	myshell=$(which zsh)
	chsh -s $myshell $USER
}

function hsep {
	echo
	echo "  .--.      .--.      .--.      .--.      .--.      .--.      .--.      .--."
	echo ":::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\::::::::.\\"
	echo "'      \`--'      \`--'      \`--'      \`--'      \`--'      \`--'      \`--'      \`"
	echo
}

hsep

# Call function according to detected distro
if grep Manjaro /etc/os-release
then
        setup_manjaro
elif grep Ubuntu /etc/os-release
then
	setup_ubuntu
elif grep CentOS /etc/os-release
then
	setup_centos
else
	echo "Unknown *Nix distro"
fi

hsep

# BASH
cp _bash/.bashrc ~/.bashrc

# TMUX
cp _tmux/.tmux.conf ~/.tmux.conf

# VIM
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp _vim/.vimrc ~/.vimrc
echo "Remember to run :PluginInstall"

# ZSH
mkdir ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh
cp _zsh/.zshrc ~/.zshrc
echo "Remember to change your shell"

hsep
echo " Done!"
hsep
