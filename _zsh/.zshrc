# zsh Settings
source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle virtualenv
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
alias vim=nvim
alias view="nvim -R"
alias whom=who

# Set editor
export EDITOR="$(which vim)"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Load up ssh keys into keychain if it is on this system
if type keychain > /dev/null; then
    sshkeylist=('id_rsa' 'id_ed25519')

    for i in $sshkeylist; do
        if [[ -e ~/.ssh/$i ]] ; then
            eval `keychain -q --eval --agents ssh $i`
        fi
    done
fi


# Functions
function get_mercury_retrograde() {
    RESULT=""
    RETROGRADETEMPFILE=~/.config/mercuryretrograde
    if ! [ -f $RETROGRADETEMPFILE ]; then
        mkdir -p ~/.config/ > /dev/null
        touch -a -m -t 197001010000.00 $RETROGRADETEMPFILE
    fi
    if type curl > /dev/null; then
        if [[ $(find "$RETROGRADETEMPFILE" -mmin +600 -print) ]]; then
            curl -s https://mercuryretrogradeapi.com > $RETROGRADETEMPFILE 2>/dev/null
        fi
        if cat $RETROGRADETEMPFILE | grep false >/dev/null ; then
            RESULT="☿ \033[0;32mPrograde\033[0m"
        else
            RESULT="☿ \033[0;31mRetrograde\033[0m"
        fi
    fi
    echo -e " $RESULT"
}

function get_ssh_keys_loaded() {
    if type keychain > /dev/null; then
        keychain -l | grep -v "The agent has no identities." | wc -l | xargs
    fi
}


# Keybinds
## ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
### urxvt
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word

## ctrl+delete
bindkey "\e[3;5~" kill-word
### urxvt
bindkey "\e[3^" kill-word

## ctrl+backspace
bindkey '^H' backward-kill-word

## ctrl+shift+delete
bindkey "\e[3;6~" kill-line
### urxvt
bindkey "\e[3@" kill-line

# Absolutely filthy way of checking if we are in windows terminal, I hate this but it works for me
SPACING="  "
SPACING2=" "
if [[ $(uname -r) == *WSL* ]]; then
  SPACING=""
  SPACING2=""
fi

# Startup welcome message, only if we are in an interactive shell
if [[ -o interactive ]]; then
    if test -f /etc/os-release; then
        . /etc/os-release
        echo -e "$PRETTY_NAME, \c"
    elif type sw_vers > /dev/null; then
        echo -e "$(sw_vers | grep -E "ProductName|ProductVersion" | awk '{print $2}' | tr '\n' ' ' | sed 's/.$//'), \c"
    fi
    echo -e "$(uname -s -r), \c"
    echo -e "🗝️$SPACING$(get_ssh_keys_loaded),$SPACING2\c"
    get_mercury_retrograde
fi
