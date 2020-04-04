# My Setup for Centos 8

## Basics

    yum install -y epel-release
    yum install -y htop zsh git tmux vim

## Docker

    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install docker-ce docker-ce-cli containerd.io
    systemctl start docker
    systemctl enable docker
