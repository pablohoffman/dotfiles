# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Honor platform defaults
# Debian
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi
# Redhat
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export HISTCONTROL=ignoredups:ignorespace

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

UC='\[\033[01;32m\]'                     # green for user
[ $UID -eq "0" ] && UC='\[\033[01;31m\]' # red for root

PS1="$UC\u@\H\[\033[00m\]:\[\033[01;34m\]\w \[\033[1;30m\][\t]\[\033[00m\]\n\\$ "

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Additional aliases in ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    if [ -e /usr/bin/dircolors -a -f ~/.dircolors ]; then
        eval "`dircolors -b ~/.dircolors`"
        alias ls='ls --color=auto'
    fi
fi

export EDITOR=vim
export PAGER="less -R"
export TSOCKS_CONF_FILE=~/.tsocksrc

if [ ! "$LANG" ]; then
    export LANG=en_US.UTF-8
fi

export PATH=$PATH:/usr/sbin:~/bin:~/.local/bin:~/.gem/ruby/1.9.1/bin

#export GPGKEY=24C071FE

#export VIRTUAL_ENV_DISABLE_PROMPT=1

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Custom functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Finally overriding by local configuration
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
