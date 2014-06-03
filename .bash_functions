#!/bin/sh
reload() {
    . ~/.bashrc
}

kssh() {
    host=$1
    shift
    (telnet $host 20301 >/dev/null 2>&1) &
    ssh $host "$@"
}
complete -F _ssh kssh

_fab() {
    local cmd commands
    cmd=${COMP_WORDS[1]}
    if [ $COMP_CWORD -eq 1 ]; then
        commands=$(fab --shortlist)
        COMPREPLY=(${COMPREPLY[@]:-} $(compgen -W "$commands" -- "$cmd"))
    fi
}
complete -F _fab -o default fab

function cdp () {
    cd "$(python -c "import os.path as _, ${1}; \
        print _.dirname(_.realpath(${1}.__file__[:-1]))"
    )"
}

e() {
    cd ~/envs/$1
    . bin/activate
    eval "$(pip completion --bash)"
}
complete -W "$(ls ~/envs 2>/dev/null)" e

# a shortcut for creating and attaching to screen sessions
scr() {
    screen -q -ls
    if [ "$?" -ge 10 ]; then
        if [ "$*" ]; then
            screen $*
        else
            screen -RD
        fi
    else
        screen
    fi
}

# ---- Work Environments ----

ORIGPATH=$PATH
ORIGPYTHONPATH=$PYTHONPATH

sc() {
    export PYTHONPATH=~/src/scrapy:~/src/w3lib:~/src/scrapely:~/src/slybot:~/src/loginform:~/src/queuelib
    export PATH=$ORIGPATH:~/src/scrapy/bin
    [ -f ~/src/scrapy/extras/scrapy_bash_completion ] && . ~/src/scrapy/extras/scrapy_bash_completion
    [ -d ~/src/scrapy/scrapy ] && cd ~/src/scrapy/scrapy
}

repodir=~/src
go() {
    sc
    d=$repodir/$1
    export PYTHONPATH=$PYTHONPATH:~/src/sophialib:~/src/scrapylib:~/src/python-scrapinghub:~/src/hubops:$d
    export PATH=$ORIGPATH:~/src/sophialib/bin:~/src/scrapy/bin
    cd $d
}
[ -d $repodir ] && {
    complete -W "$(find ~/src -maxdepth 1 -type d -printf '%f\n')" go
}

# dotfiles git wrapper
alias dotgit="GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ git"
alias dottig="GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ tig"
complete -o bashdefault -o default -o nospace -F _git dotfiles
dotsync (){
    (
        cd ~
        dotfiles pull origin master -u
    )
}
