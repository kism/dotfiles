# shellcheck shell=bash # Technically incorrect but shellcheck doesn't support zsh, it works decent
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
if [ "$TERM" = "xterm-ghostty" ]; then # Fix while I work out the setting
    export TERM=xterm-256color
fi
load_ssh_keys
# endregion

# region: history
setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing non-existent history.
HISTFILE=~/.zsh_history
HISTSIZE=10000
# endregion

# region keybinds
# Search with up and down arrows
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

## ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

# delete
bindkey "\e[3~" delete-char

## ctrl+delete
bindkey "\e[3;5~" kill-word

## ctrl+backspace
bindkey '^H' backward-kill-word

## ctrl+shift+delete
bindkey "\e[3;6~" kill-line
# endregion

# region: root user
if [[ $EUID -eq 0 ]]; then
    export PS1="%{%F{196}%}%n%{%F{202}%}@%{%F{208}%}%m %{%F{220}%}%~
%{%F{196}%}#%{%f%} "
    autoload -U compinit; compinit
    zstyle ':completion:*' menu select
    bindkey '^[[A' up-line-or-search
    bindkey '^[[B' down-line-or-search
    return # End early since nothing following matters for root
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

# region: zsh settings, handled by zinit

# export LC_CTYPE=en_US.UTF-8 # Hopefully fix double characters

# Fallback
export PS1="%{%F{39}%}%n%{%F{45}%}@%{%F{51}%}%m %{%F{195}%}%~
%{%F{39}%}$%{%f%} "

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
## End of Zinit's installer chunk

# zinit packages, mostly use Pretzo plugins
zi snippet PZTM::environment
zi snippet PZTM::terminal
# zi snippet PZTM::editor # I do this myself instead, can't get history-substring-search to work
# zi snippet PZTM::history # I do this myself instead
zi snippet PZTM::directory
zi snippet PZTM::utility
zi snippet PZTM::completion
zi light zdharma-continuum/fast-syntax-highlighting

zi load 'zsh-users/zsh-history-substring-search'
# zi light zsh-users/zsh-autosuggestions # Naa

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zi load 'matthiasha/zsh-uv-env' # Load Python virtual environments per UV

# Starship handles the prompt
zi ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zi light starship/starship
