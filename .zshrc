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
            curl -s https://mercuryretrogradeapi.com >|$RETROGRADETEMPFILE 2>/dev/null
        fi
        if cat $RETROGRADETEMPFILE | grep false >/dev/null; then
            RESULT="☿$SPACING_SYMBOLS_AFTER\033[0;32mPrograde\033[0m"
        else
            RESULT="☿$SPACING_SYMBOLS_AFTER\033[0;31mRetrograde\033[0m"
        fi
    fi
    echo -e "$RESULT"
}

function load_ssh_keys() {
    # This also fixes vscode
    # shellcheck disable=SC2206 # zsh
    # shellcheck disable=SC2296 # zsh
    # shellcheck disable=SC2010 # use ls to prevent unwanted printing
    SSH_AGENT_FOLDERS=(${(f)$(ls -1 /tmp | grep ssh)})
    # shellcheck disable=SC2128 # zsh
    if [[ -n "$SSH_AGENT_FOLDERS" ]]; then
        SSH_AUTH_SOCK=$(find "/tmp/ssh-*" -type s -print0 2>/dev/null)
        export SSH_AUTH_SOCK
    fi

    # Load up ssh keys into keychain if it is on this system
    if type keychain >/dev/null; then
        sshkeylist=('id_rsa' 'id_ed25519')

        # shellcheck disable=SC2128 # This is fine in zsh
        for i in $sshkeylist; do
            if [[ -e ~/.ssh/$i ]]; then
                if ! eval "$(keychain -q --eval --agents ssh "$i")"; then
                    echo "Keychain failed to load $i"
                    echo "run 'ssh-agent -s', kill the pid listed 'kill -9 PID' and try again"
                fi
            fi
        done
    fi
}

function get_ssh_keys_loaded() {
    KEYS_LOADED="0"

    if type keychain >/dev/null; then # If keychain is installed we check if we have keys loaded
        KEYS_LOADED=$(keychain -l 2>/dev/null | grep -c "The agent has no identities." | xargs)
    fi
    if [[ ! "$SSH_AUTH_SOCK" == "" ]]; then # If we have an SSH_AUTH_SOCK we have a key loaded
        KEYS_LOADED=$((KEYS_LOADED + 1))
    fi
    echo "$KEYS_LOADED"
}

function check_modern_terminal() {
    if [[ "$TERM" != vt* && "$TERM" != linux && "$TERM" != linux && "$TERM" != dumb ]]; then # Easier to check if it not a legacy terminal
        return 0                                                                             # Zero is success/true
    else
        return 1
    fi
}

# endregion

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
    # echo -e "🗝️$EXTRA_SPACING_EMOJI$(get_ssh_keys_loaded),$SPACING_SYMBOLS_BEFORE\c"
    get_mercury_retrograde
# else
    # echo -e "SSH KEYS: $(get_ssh_keys_loaded)"
fi
# endregion

# region: instant prompt
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
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

# ZSH_DISABLE_COMPFIX="true"

# region: antigen
if [[ $EUID -eq 0 ]]; then
    autoload -U compinit; compinit
    zstyle ':completion:*' menu select
    export PS1="%{%F{196}%}%n%{%F{202}%}@%{%F{208}%}%m %{%F{220}%}%~
%{%F{196}%}#%{%f%} "
elif [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    # Load Presto
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
else
    autoload -U compinit; compinit
    zstyle ':completion:*' menu select
        export PS1="%{%F{39}%}%n%{%F{45}%}@%{%F{51}%}%m %{%F{195}%}%~
%{%F{196}%}#%{%f%} "
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
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
    export ZSH_DISABLE_COMPFIX="true" # Brew multiuser
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES # Unbreak ansible on macos
fi
load_ssh_keys
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

export ANSIBLE_AD_USERNAME=kgee

# Hopefully fix double characters
export LC_CTYPE=en_US.UTF-8

# Fix while I work out the setting
if [ "$TERM" = "xterm-ghostty" ]; then
    export TERM=xterm-256color
fi


if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion:wq
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
