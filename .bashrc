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
export PAGER=less
export TSOCKS_CONF_FILE=~/.tsocksrc

[ -x /usr/bin/ack-grep ] && {
    export HAVEACK=1 # used in .vimrc
}

if [ ! "$LANG" ]; then
    export LANG=en_US.UTF-8
fi

# FreeBSD
export BLOCKSIZE=K
export CLICOLOR=1

export PATH=$PATH:/usr/sbin:~/bin

# Mac OSX
[ -d /opt/local/bin ] && export PATH=$PATH:/opt/local/bin
[ -r /sw/bin/init.sh ] && . /sw/bin/init.sh

# per host configuration
[ "$HOSTNAME" = "130336-spider1.prod.mydeco.com" ] && {
    export PATH=$PATH:/opt/scraping/bin
}

#export GPGKEY=24C071FE

export WORKON_HOME=~/envs
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Add some paths if they exist
[ -d ~/.gem/ruby/1.8/bin ] && export PATH=$PATH:~/.gem/ruby/1.8/bin

# Amazon EC2
if [ -d /opt/ec2 ]; then
    export EC2_HOME=/opt/ec2
    export EC2_PRIVATE_KEY=~/.ec2/pk-FQ7QZ5VZA4PDMNPMFRPBCF7BQMECGPYW.pem
    export EC2_CERT=~/.ec2/cert-FQ7QZ5VZA4PDMNPMFRPBCF7BQMECGPYW.pem
    export PATH=$PATH:/opt/ec2/bin
    export JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.06/jre/
fi

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

# Custom host configuration
if [ -f ~/.bash_hosts ]; then
    . ~/.bash_hosts
fi

# Finally overriding by local configuration
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
