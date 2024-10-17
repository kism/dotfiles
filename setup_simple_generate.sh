#! /usr/bin/env bash

echo > generated.txt

echo "echo --- Start ---" >> generated.txt

echo 'cat > ~/.bash_profile << "EOF"' >> generated.txt
cat .bash_profile >> generated.txt
echo "EOF" >> generated.txt

echo >> generated.txt

echo 'cat > ~/.bashrc << "EOF"' >> generated.txt
cat .bashrc >> generated.txt
echo "EOF" >> generated.txt

echo >> generated.txt

echo 'cat > ~/.bash_aliases << "EOF"' >> generated.txt
cat .bash_aliases >> generated.txt
echo "EOF" >> generated.txt

echo >> generated.txt

echo 'cat > ~/.inputrc << "EOF"' >> generated.txt
cat .inputrc >> generated.txt
echo "EOF" >> generated.txt

echo >> generated.txt

echo 'cat > ~/.tmux.conf << "EOF"' >> generated.txt
cat .tmux.conf >> generated.txt
echo "EOF" >> generated.txt

echo >> generated.txt


echo 'cat > ~/.vimrc << "EOF"' >> generated.txt
cat .vimrc >> generated.txt
echo "EOF" >> generated.txt

echo >> generated.txt

echo "source ~/.bashrc" >> generated.txt
echo "bind -f ~/.inputrc" >> generated.txt
echo "echo" >> generated.txt
echo "echo --- Done ---" >> generated.txt
