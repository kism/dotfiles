#!/usr/bin/env bash

# Download all the dotfiles
# Exit the script if there is an error
set -e

BASE=https://raw.githubusercontent.com/kism/dotfiles/main

get() {
    echo "Setting up $1..."
    mkdir -p "$(dirname ~/"$1")"
    curl --fail --silent -L "$BASE/$1" -o ~/"$1"
}

for f in .bashrc .bash_profile .bash_aliases .inputrc .tmux.conf .vimrc .config/nvim/init.lua \
    .config/htop/htoprc .config/btop/btop.conf .terminfo/g/ghostty .terminfo/x/xterm-ghostty; do
    get "$f"
done

# ponytail: hand-copied subset of .zshrc (no plugins/functions/startup message/starship), resync by hand if .zshrc changes
echo "Setting up .zshrc..."
cat >~/.zshrc <<'EOF'
# .zshrc (simple)
# Full version: https://github.com/kism/dotfiles/blob/main/.zshrc

# region: non-interactive
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [[ ! -o interactive ]]; then
    return
fi
# endregion

# region: aliases
alias ip='ip --color=auto'
alias please='sudo $(fc -ln -1)'
alias sudp='sudo'
alias tmux='tmux -u'
alias sl='ls'

if [[ "$OSTYPE" != darwin* ]]; then
    alias ls='ls --color=auto --group-directories-first -F'
elif type gls >/dev/null; then # GNU ls from brew coreutils
    alias ls='gls --color=auto --group-directories-first -F'
else
    alias ls='ls --color=auto -F'
fi
alias nano='vim'
alias bim='echo -e "\033[0;31m\033[0;41mB\033[0mim"'
alias screen='echo no #'
alias cgrep='grep --color=always -e "^" -e'
alias youtube-dl='yt-dlp -o "%(upload_date)s %(title)s [%(id)s].%(ext)s"'
alias whom=who
# endregion

# region: editor
if type nvim >/dev/null; then
    alias vim=nvim
    alias view="nvim -R"
fi
export EDITOR=vim
export VISUAL=vim
# endregion

# region: exports
export VIRTUAL_ENV_DISABLE_PROMPT=1
if [[ "$OSTYPE" == darwin* ]]; then
    export ZSH_DISABLE_COMPFIX="true"
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
else
    export SYSTEMD_COLORS=true
    export SYSTEMD_PAGER=
fi
# endregion

# region: history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# endregion

# region: keybinds
zmodload zsh/terminfo

if [[ "$OSTYPE" == darwin* ]] && [[ $EUID -eq 0 ]]; then
    export TERM="xterm-256color"
fi

bindkey -r "^["
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "^[f" forward-word
bindkey "^[b" backward-word
bindkey "${terminfo[kdch1]}" delete-char
bindkey "${terminfo[kbs]}" backward-delete-char
bindkey "\e[3;5~" kill-word
bindkey '^H' backward-kill-word
bindkey "\e[3;6~" kill-line
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
# endregion

# region: prompt + completion
if [[ $EUID -eq 0 ]]; then
    export PS1="%{%F{196}%}%n%{%F{202}%}@%{%F{208}%}%m %{%F{220}%}%~
%{%F{196}%}#%{%f%} "
else
    export PS1="%{%F{39}%}%n%{%F{45}%}@%{%F{51}%}%m %{%F{195}%}%~
%{%F{39}%}$%{%f%} "
fi

autoload -Uz compinit
compinit -i
zstyle ':completion:*' menu select
# endregion

# region: local programming tools
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"
command -v kubectl >/dev/null && source <(kubectl completion zsh)
command -v docker >/dev/null && source <(docker completion zsh)
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)"
true
# endregion
EOF

if [ $EUID -eq 0 ]; then # If this is setting up the root user account, make the tmux bar red
    sed -i 's/green/red/g' ~/.tmux.conf
    sed -i 's/colour10/colour9/g' ~/.tmux.conf
fi

if [ "$1" == "--gui" ]; then
    get .config/ghostty/config.ghostty
fi
