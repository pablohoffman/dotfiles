#!/bin/sh

alias ack='ack-grep'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color'
alias less='less -n'
alias rmpyc="find -name '*.pyc' -delete -or -name '*\$py.class' -delete"
alias rmrej="find -name '*.rej' -delete"
alias rmorig="find -name '*.orig' -delete"
alias rmall="rmpyc; rmrej; rmorig"
alias vj="python -m json.tool"
alias vjl="python -m json.tool | less"
alias upapt="sudo apt-get -qq update && sudo apt-get install"
alias goerl14=". /opt/erlang/r14b04/activate"
alias ipy="ipython"
alias py="python"

[ -f /usr/bin/vim -o -f /usr/local/bin/vim ] && alias vi='vim'
