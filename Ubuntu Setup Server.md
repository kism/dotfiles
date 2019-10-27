# My Setup for Ubuntu Server 19.10

## Updates & Packages

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install openssh-server htop zsh git tmux vim squid qbittorrent-nox -y

## Virtualbox Tools

    sudo mount /dev/cdrom /media/vmtools
    cd /media/vmtools/
    sudo ./VBoxLinuxAdditions.run

## Wireguard

    modprobe wireguard
    lsmod | grep wireguard

## Mullvad

### Setup

wget the latest version of mullvad from https://github.com/mullvad/mullvadvpn-app/releases

     wget         <link to mullvad deb>
     sudo dpkg -i <mullvad deb>

### Config

    mullvad account set <account number>
    mullvad tunnel wireguard key generate
    mullvad tunnel wireguard key check
    mullvad relay set tunnel wireguard any
    mullvad relay set location sg sin
    mullvad lan set allow
    mullvad connect
    mullvad block-when-disconnected set on