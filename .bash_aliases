# shellcheck shell=bash
# .bash_aliases
# https://github.com/kism/dotfiles-simple/blob/main/.bash_aliases

alias ls='ls --color=auto --group-directories-first -F'
alias ll='ls -lh --color=auto --group-directories-first'
alias la='ls -halal --color=auto --group-directories-first'
alias sl='ls --color=auto --group-directories-first'

alias please='sudo $(fc -ln -1)'
alias sudp='sudo'
alias tmux='tmux -u'
alias sl='ls'
alias nano='vim'
alias ip='ip --color=auto'
alias bim='echo -e "\033[0;31m\033[0;41mB\033[0mim"'
alias screen='echo no #'
# Colour grep, Print whole file, colour the matches
alias cgrep='grep --color=always -e "^" -e'
alias whom=who
alias yay_noconfirm='yay --noconfirm --needed --cleanafter'
alias jctl=journalctl
alias sctl=systemctl

if type nvim >/dev/null 2>&1; then
    alias vim=nvim
    alias view="nvim -R"
fi
