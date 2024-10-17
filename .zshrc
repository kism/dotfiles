# shellcheck shell=bash # Technically incorrect but shellcheck doesn't support zsh
# .zshrc
# https://github.com/kism/dotfiles-simple/blob/main/.zshrc
# shellcheck source=/dev/null

# region Functions
# Due to weirdness with emojis, we need these variables
if [[ "$TERM_PROGRAM" == vscode ]]; then # Check if we are in a vscode terminal
    EXTRA_SPACING_EMOJI=" "
    SPACING_SYMBOLS_AFTER=" "
    SPACING_SYMBOLS_BEFORE=""
elif [[ "$TERM" == alacritty ]]; then
    EXTRA_SPACING_EMOJI=" "
    SPACING_SYMBOLS_AFTER=""
    SPACING_SYMBOLS_BEFORE=""
else
    EXTRA_SPACING_EMOJI=""
    SPACING_SYMBOLS_AFTER=" "
    SPACING_SYMBOLS_BEFORE=" "
fi

function get_mercury_retrograde() {
    RESULT=""
    RETROGRADETEMPFILE=~/.config/mercuryretrograde
    if ! [ -f $RETROGRADETEMPFILE ]; then
        mkdir -p ~/.config/ >/dev/null
        touch -a -m -t 197001010000.00 $RETROGRADETEMPFILE
    fi
    if type curl >/dev/null; then
        if [[ $(find "$RETROGRADETEMPFILE" -mmin +600 -print) ]]; then
            curl -s https://mercuryretrogradeapi.com >$RETROGRADETEMPFILE 2>/dev/null
        fi
        if cat $RETROGRADETEMPFILE | grep false >/dev/null; then
            RESULT="☿$SPACING_SYMBOLS_AFTER\033[0;32mPrograde\033[0m"
        else
            RESULT="☿$SPACING_SYMBOLS_AFTER\033[0;31mRetrograde\033[0m"
        fi
    fi
    echo -e " $RESULT"
}

function get_ssh_keys_loaded() {
    KEYS_LOADED="0"
    if type keychain >/dev/null; then # If keychain is installed we check if we have keys loaded
        KEYS_LOADED=$(keychain -l | grep -c "The agent has no identities." | xargs)
    fi
    if [[ ! "$SSH_AUTH_SOCK" == "" ]]; then # If we have an SSH_AUTH_SOCK we have a key loaded
        KEYS_LOADED=$((KEYS_LOADED + 1))
    fi
    echo "$KEYS_LOADED"
}

function check_modern_terminal() {
    if [[ "$TERM" != vt* && "$TERM" != linux && "$TERM" != linux && "$TERM" != dumb ]]; then # Easier to check if it not a legacy terminal
        return 0 # Zero is success/true
    else
        return 1
    fi
}

# endregion

# region: non-interactive
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# If we are not an interactive shell, don't do anything else
if [[ ! -o interactive ]]; then
    return
fi
# endregion

# region: antigen
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

# Poetry
antigen bundle darvid/zsh-poetry

# fish like completion
# antigen bundle zsh-users/zsh-completions
# antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme kism/zsh-bira-mod

# Tell Antigen that you're done.
antigen apply
# endregion

# region: aliases
alias please='sudo $(fc -ln -1)'
alias sudp='sudo'
alias tmux='tmux -u'
alias sl='ls'
alias nano='vim'
alias bim='echo -e "\033[0;31m\033[0;41mB\033[0mim"'
alias screen='echo no #'
alias cgrep='grep --color=always -e "^" -e'
alias youtube-dl='yt-dlp -o "%(upload_date)s %(title)s [%(id)s].%(ext)s"'
alias whom=who

if type nvim >/dev/null; then
    alias vi=nvim
    alias vim=nvim
    alias view="nvim -R"
fi
# endregion

# region: exports
export EDITOR=nvim
export VISUAL=nvim
export VIRTUAL_ENV_DISABLE_PROMPT=1 # VSCode Fix?
if [[ "$OSTYPE" == darwin* ]]; then
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES # Unbreak ansible on macos
fi
SSH_AUTH_SOCK=$(find /tmp/ssh-* -type s -print0 2>/dev/null | xargs -0 ls -t | head -1) # VSCode Fix
export SSH_AUTH_SOCK
# endregion

# region keybinds
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
# endregion

# Load up ssh keys into keychain if it is on this system
if type keychain >/dev/null; then
    sshkeylist=('id_rsa' 'id_ed25519')

    # shellcheck disable=SC2128 # This is fine in zsh
    for i in $sshkeylist; do
        if [[ -e ~/.ssh/$i ]]; then
            eval "$(keychain -q --eval --agents ssh "$i")"
        fi
    done
fi

# region: startup message
# Operating system
if test -f /etc/os-release; then # Linux
    source /etc/os-release
    echo -e "$PRETTY_NAME, \c"
elif type sw_vers >/dev/null; then # MacOS
    echo -e "$(sw_vers | grep -E "ProductName|ProductVersion" | awk '{print $2}' | tr '\n' ' ' | sed 's/.$//'), \c"
fi

# Kernel version
echo -e "$(uname -s -r), \c"

# Ssh keys loaded, mercury retrograde
if check_modern_terminal; then
    echo -e "🗝️$EXTRA_SPACING_EMOJI$(get_ssh_keys_loaded),$SPACING_SYMBOLS_BEFORE\c"
    get_mercury_retrograde
else
    echo -e "SSH KEYS: $(get_ssh_keys_loaded)"
fi
# endregion

# region: cleanup
# For some reason the theme doesn't get applied when sourcing manually, this checks if we are sourcing the file and applies the theme if so
if [[ $0 = *".zshrc" ]]; then
    echo -e "\033[0;32mFinished sourcing .zshrc!\033[0m"
    source ~/.antigen/bundles/kism/zsh-bira-mod/bira-mod.zsh-theme
fi
# endregion
