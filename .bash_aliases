#!/bin/sh

alias mq='hg -R $(hg root)/.hg/patches' 
alias fs='hadoop fs'
alias m='mutt'
alias sup='sup-mail'
alias ack='ack-grep'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color'
alias less='less -nr'
alias hgp="hg pull -u"
alias hgcl="find -name '*.orig' -delete"
alias rmpyc="find -name '*.pyc' -delete"
alias rmrej="find -name '*.rej' -delete"
alias rmorig="find -name '*.orig' -delete"
alias vj="py -msimplejson.tool"
alias vjl="py -msimplejson.tool | less"
alias lock="gnome-screensaver-command --lock"
alias ipy="ipython"
alias py="python"
alias apti="sudo apt-get update && sudo apt-get install"

[ -f /usr/bin/vim -o -f /usr/local/bin/vim ] && alias vi='vim'
