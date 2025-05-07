# .zshrc
# https://github.com/kism/dotfiles-simple/blob/main/.zshrc

# region Functions
# Due to weirdness with emojis, we need these variables
if [[ "$TERM_PROGRAM" == vscode ]]; then # Check if we are in a vscode terminal
    EXTRA_SPACING_EMOJI=" "
    SPACING_SYMBOLS_AFTER=" "
    SPACING_SYMBOLS_BEFORE=" "
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
            curl --max-time 5 -s https://mercuryretrogradeapi.com >$RETROGRADETEMPFILE 2>/dev/null
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
    SSH_AGENT_FOLDERS=(${(f)$(ls -1 /tmp | grep ssh)})
    if [[ -n "$SSH_AGENT_FOLDERS" ]]; then
        export SSH_AUTH_SOCK=$(/bin/ls -t /tmp/ssh-**/* | head -1)
    fi

    # Load up ssh keys into keychain if it is on this system
    if type keychain >/dev/null; then
        sshkeylist=('id_rsa' 'id_ed25519')

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
    # if type keychain >/dev/null; then # If keychain is installed we check if we have keys loaded
    #     KEYS_LOADED=$(keychain -l 2>/dev/null | grep -c "The agent has no identities." | xargs)
    # fi
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
alias ip='ip --color=auto'
alias please='sudo $(fc -ln -1)'
alias sudp='sudo'
alias tmux='tmux -u'
alias sl='ls'

if [[ "$OSTYPE" == darwin* ]] && [[ $(type gls >/dev/null) != 0 ]] ; then
    alias ls='ls --color=auto -F'
else
    alias ls='ls --color=auto --group-directories-first -F'
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
    alias vi=nvim
    alias vim=nvim
    alias view="nvim -R"
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=vim
    export VISUAL=vim
fi
# endregion

# region: exports
export VIRTUAL_ENV_DISABLE_PROMPT=1 # VSCode Fix?
if [[ "$OSTYPE" == darwin* ]]; then
    export ZSH_DISABLE_COMPFIX="true" # Brew multiuser
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES # Unbreak ansible on macos
else
    export SYSTEMD_COLORS=true
    export SYSTEMD_PAGER=
fi
load_ssh_keys
# endregion

# region: history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
## History command configuration, from oh-my-zsh
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Enable beginning-search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# endregion

# region keybinds
# https://en.wikipedia.org/wiki/ANSI_escape_code
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
# https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/lib/key-bindings.zsh

# Thank you apple for this code
# Use keycodes (generated via zkbd) if present, otherwise fallback on
# values from terminfo
if [[ -r ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR} ]] ; then
    source ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR}
    echo yep
else
    typeset -g -A key
    echo "nope: ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR}"

    [[ -n "$terminfo[kf1]" ]] && key[F1]=$terminfo[kf1]
    [[ -n "$terminfo[kf2]" ]] && key[F2]=$terminfo[kf2]
    [[ -n "$terminfo[kf3]" ]] && key[F3]=$terminfo[kf3]
    [[ -n "$terminfo[kf4]" ]] && key[F4]=$terminfo[kf4]
    [[ -n "$terminfo[kf5]" ]] && key[F5]=$terminfo[kf5]
    [[ -n "$terminfo[kf6]" ]] && key[F6]=$terminfo[kf6]
    [[ -n "$terminfo[kf7]" ]] && key[F7]=$terminfo[kf7]
    [[ -n "$terminfo[kf8]" ]] && key[F8]=$terminfo[kf8]
    [[ -n "$terminfo[kf9]" ]] && key[F9]=$terminfo[kf9]
    [[ -n "$terminfo[kf10]" ]] && key[F10]=$terminfo[kf10]
    [[ -n "$terminfo[kf11]" ]] && key[F11]=$terminfo[kf11]
    [[ -n "$terminfo[kf12]" ]] && key[F12]=$terminfo[kf12]
    [[ -n "$terminfo[kf13]" ]] && key[F13]=$terminfo[kf13]
    [[ -n "$terminfo[kf14]" ]] && key[F14]=$terminfo[kf14]
    [[ -n "$terminfo[kf15]" ]] && key[F15]=$terminfo[kf15]
    [[ -n "$terminfo[kf16]" ]] && key[F16]=$terminfo[kf16]
    [[ -n "$terminfo[kf17]" ]] && key[F17]=$terminfo[kf17]
    [[ -n "$terminfo[kf18]" ]] && key[F18]=$terminfo[kf18]
    [[ -n "$terminfo[kf19]" ]] && key[F19]=$terminfo[kf19]
    [[ -n "$terminfo[kf20]" ]] && key[F20]=$terminfo[kf20]
    [[ -n "$terminfo[kbs]" ]] && key[Backspace]=$terminfo[kbs]
    [[ -n "$terminfo[kich1]" ]] && key[Insert]=$terminfo[kich1]
    [[ -n "$terminfo[kdch1]" ]] && key[Delete]=$terminfo[kdch1]
    [[ -n "$terminfo[khome]" ]] && key[Home]=$terminfo[khome]
    [[ -n "$terminfo[kend]" ]] && key[End]=$terminfo[kend]
    [[ -n "$terminfo[kpp]" ]] && key[PageUp]=$terminfo[kpp]
    [[ -n "$terminfo[knp]" ]] && key[PageDown]=$terminfo[knp]
    [[ -n "$terminfo[kcuu1]" ]] && key[Up]=$terminfo[kcuu1] && echo yep up
    [[ -n "$terminfo[kcub1]" ]] && key[Left]=$terminfo[kcub1]
    [[ -n "$terminfo[kcud1]" ]] && key[Down]=$terminfo[kcud1]
    [[ -n "$terminfo[kcuf1]" ]] && key[Right]=$terminfo[kcuf1]
fi

# Home, end
# bindkey "${key[Home]}" beginning-of-line
bindkey "${key[Home]}" beginning-of-line
bindkey "${key[End]}" end-of-line

## ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

## alt+arrows
bindkey "^[f" forward-word
bindkey "^[b" backward-word

## Command+arrows
bindkey -r "^E"
bindkey -r "^A"

# delete
bindkey "${key[Delete]}" delete-char

# backspace
# bindkey -v '^?' backward-delete-char
bindkey "${key[Backspace]}" backward-delete-char

## ctrl+delete
bindkey "\e[3;5~" kill-word

## ctrl+backspace
bindkey '^H' backward-kill-word

## ctrl+shift+delete
bindkey "\e[3;6~" kill-line

# Up, down
bindkey "${key[Up]}" up-line-or-beginning-search
bindkey "${key[Down]}" down-line-or-beginning-search
## Up, down, God know why, ghostty?
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# endregion

# region: root user
if [[ $EUID -eq 0 ]]; then
    export PS1="%{%F{196}%}%n%{%F{202}%}@%{%F{208}%}%m %{%F{220}%}%~
%{%F{196}%}#%{%f%} "
    autoload -U compinit; compinit
    zstyle ':completion:*' menu select
    return # End early since nothing following matters for root
fi
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
    echo -e "🗝️$EXTRA_SPACING_EMOJI$(get_ssh_keys_loaded),$SPACING_SYMBOLS_BEFORE\c"
    get_mercury_retrograde
else
    echo -e "SSH KEYS: $(get_ssh_keys_loaded)"
fi
# endregion

# Local Programming tools
## Node Version Manager
if [ -d "$HOME/.nvm" ]; then
    autoload -U +X compinit && compinit # TODO FIXME?
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Rust
if [ -f ~/.cargo/env ]; then
    source "$HOME/.cargo/env"
fi

# region: zsh settings, handled by zinit

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
bindkey "^[[5~" history-substring-search-up   # Page Up
bindkey "^[[6~" history-substring-search-down # Page Down

# zi light zsh-users/zsh-autosuggestions # Naa

zi load 'matthiasha/zsh-uv-env' # Load Python virtual environments per UV

# Starship handles the prompt
zi ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zi light starship/starship
