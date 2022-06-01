source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# fish like completion
# antigen bundle zsh-users/zsh-completions
# antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme kism/zsh-bira-mod

# Tell Antigen that you're done.
antigen apply

# Alias
alias please='sudo $(fc -ln -1)'
alias sudp='sudo'
alias tmux='tmux -u'
alias sl='ls'
alias nano='vim'
alias bim='echo -e "\033[0;31m\033[0;41mB\033[0mim"'
alias screen='echo no #'
alias cgrep='grep --color=always -e "^" -e'
alias youtube-dl='yt-dlp -o "%(upload_date)s %(title)s [%(id)s].%(ext)s"'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Make this a nice list in the future
if type keychain > /dev/null; then
    if test -f "~/.ssh/id_rsa"; then
        eval `keychain -q --eval --agents ssh id_rsa`
    fi
    if test -f "~/.ssh/id_ed25519"; then
        eval `keychain -q --eval --agents ssh id_ed25519`
    fi
fi
