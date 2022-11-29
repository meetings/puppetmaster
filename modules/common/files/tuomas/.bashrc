# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export CDPATH=".:~"
export LESSCHARSET="utf-8"
export VISUAL=/usr/bin/vim
export PATH=$HOME/bin:/usr/sbin:/usr/bin:/sbin:/bin

export HISTSIZE=1024
export HISTFILESIZE=4096
export HISTIGNORE=exit
export HISTCONTROL=ignoreboth

set -o ignoreeof
shopt -s cdspell checkjobs checkwinsize extglob histappend globstar

unalias ls &>/dev/null

alias ..='cd ..'
alias ...='cd ../..'
alias cp='/bin/cp -iv'
alias mv='/bin/mv -iv'
alias rm='/bin/rm -v'
alias chmod='chmod -c'
alias grep='grep --color=auto'
alias flush='for s in $(seq 55); do echo; done'
alias ssync='rsync -rtvP -e ssh -B 8192 --stats'
alias ll='ls -lp --color=auto --group-directories-first'
alias l=':'

mkcd() { mkdir -pv "$@" && cd "$1"; }

lpgrep() {
    while [ -n "$1" ]; do
        pgrep $1 | ifne xargs ps wu | tail -n +2
        shift
    done
}

if tput setaf 1; then
    RST=$(tput sgr0)
    BLD=$(tput bold)
    ULN=$(tput smul)
    RED=$(tput setaf 1)
    YEL=$(tput setaf 3)
    BLU=$(tput setaf 4)
    MAG=$(tput setaf 5)
    WHI=$(tput setaf 7)

    export LESS_TERMCAP_md=$BLD$MAG
    export LESS_TERMCAP_me=$RST
    export LESS_TERMCAP_so=$BLD$RED
    export LESS_TERMCAP_se=$RST
    export LESS_TERMCAP_us=$ULN$MAG
    export LESS_TERMCAP_ue=$RST

    PS1="\[$YEL\][\h] \[$BLU\]\w \$\[$RST\] "
    PS2="\[$WHI\]>\[$RST\] "
fi

[ -f ~/.dircolors ] && eval $(dircolors ~/.dircolors)

if   [[ "$(hostname)" =~ front ]]; then
    export OLDPWD=/etc/perlbal
elif [[ "$(hostname)" =~ log ]]; then
    export OLDPWD=/var/log
fi
