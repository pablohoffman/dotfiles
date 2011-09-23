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
alias less='less -n'
alias hgp="hg pull -u"
alias hgcl="find -name '*.orig' -delete"
alias rmpyc="find -name '*.pyc' -delete"
alias rmrej="find -name '*.rej' -delete"
alias rmorig="find -name '*.orig' -delete"
alias rmall="rmpyc; rmrej; rmorig"
alias vj="py -msimplejson.tool"
alias vjl="py -msimplejson.tool | less"
alias lock="gnome-screensaver-command --lock"

# to support running ipython/nosetests/trial/twistd on virtualenv
alias ipython="python /usr/bin/ipython"
alias ipy="python /usr/bin/ipython"
alias nosetests="python /usr/bin/nosetests"
alias trial="python /usr/bin/trial"
alias twistd="python /usr/bin/twistd"
alias pylint="python /usr/bin/pylint"
alias py="python"
# upgrade package
alias aptup="sudo apt-get -qq update && sudo apt-get install"

[ -f /usr/bin/vim -o -f /usr/local/bin/vim ] && alias vi='vim'
