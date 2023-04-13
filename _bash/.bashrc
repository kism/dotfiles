# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Prompt
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
    echo -e $RESULT
}
export PS1="[\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]] \w\n\[\e[35m\]\\$\[\e[m\] "

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Alias
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias la='ls -halal --color=auto'
alias sl='ls --color=auto'

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

# Startup
if test -f /etc/os-release; then
    . /etc/os-release
    echo -e "$PRETTY_NAME, \c"
fi
echo -e "$(uname -s -r), \c"
get_mercury_retrograde
