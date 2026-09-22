#!/usr/bin/env bash

{
    echo
    echo "echo --- Start ---"
    for f in .bash_profile .bashrc .bash_aliases .inputrc .tmux.conf .vimrc; do
        echo "cat > ~/$f << \"EOF\""
        cat "$f"
        echo "EOF"
        echo
    done
    echo "source ~/.bashrc"
    echo "bind -f ~/.inputrc"
    echo "echo"
    echo "echo --- Done ---"
} >generated.txt
