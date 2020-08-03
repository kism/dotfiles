#!/bin/bash

baseinstall="vim zsh git htop tmux openssh-server curl" 

function setup_manjaro {
	hsep
	sudo pacman -Syyu
	sudo pacman -Sy $baseinstall
	set_shell_chsh
}

function setup_ubuntu {
	hsep
	sudo apt update
	sudo apt upgrade
	sudo apt install -y $baseinstall
	set_shell_chsh
}

function setup_centos {
	hsep
	sudo yum clean all
	sudo yum update
	sudo yum install -y epel-release
	sudo yum install -y $baseinstall
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

function hheader () {
	echo
	echo "$1"
	echo "_____________________________________________________________________________"
	echo
}

hsep

# Start
echo "Installing packages will require sudo"
sudo echo

if [ $? -eq 0 ]
then
  echo "Starting install"
else
  echo "sudo failed" >&2
  exit 1
fi

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
hheader "Setting up bash"
cp _bash/.bashrc ~/.bashrc

# TMUX
hheader "Setting up tmux"
cp _tmux/.tmux.conf ~/.tmux.conf

# VIM
hheader "Setting up vim"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp _vim/.vimrc ~/.vimrc
echo "Remember to run :PluginInstall"

# ZSH
hheader "Setting up zsh"
mkdir ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh
cp _zsh/.zshrc ~/.zshrc
echo "Remember to change your shell"

hsep
echo " Done!"
hsep
