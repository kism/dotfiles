# My Setup for pretty much any Ubuntu install

## Updates & Packages

    sudo apt install zsh git tmux vim openssh-server
    sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
    sudo fc-cache -f -v


## zsh

    mkdir ~/.antigen
    curl -L git.io/antigen > ~/.antigen/antigen.zsh
    chsh -s /bin/zsh

    cp .zshrc ~/.zshrc

## vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    cp .vimrc ~/.vimrc

Remember to run :PluginInstall


## tmux
    cp .tmux.config ~/.tmux.config

## bash
    cp .bashrc ~/.bashrc
