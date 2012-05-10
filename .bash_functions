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

pp() { # add path to python path
    export PYTHONPATH=$1:$PYTHONPATH
}

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
    export PYTHONPATH=~/src/scrapy:~/src/w3lib:~/src/scrapely:~/src/slybot
    export PATH=$ORIGPATH:~/src/scrapy/bin
    [ -f ~/src/scrapy/extras/scrapy_bash_completion ] && . ~/src/scrapy/extras/scrapy_bash_completion
    [ -d ~/src/scrapy/scrapy ] && cd ~/src/scrapy/scrapy
}

projects_dir=~/src
go() { # go to hg project
    sc
    d=$projects_dir/$1
    export PYTHONPATH=$PYTHONPATH:~/src/sophialib:~/src/scrapylib:~/src/python-scrapinghub:$d
    export PATH=$ORIGPATH:~/src/sophialib/bin:~/src/scrapy/bin
    cd $d
}
[ -d $projects_dir ] && {
    complete -W "$(find ~/src -maxdepth 1 -type d -printf '%f\n')" go
}

env-h() {
    [ -f ~/aws/shub ] && . ~/aws/shub
    sc
    d=~/src/scrapinghub
    export PATH=$PATH:$d/bin
    export PYTHONPATH=$d:~/src/sophialib:$PYTHONPATH
    cd $d
}

env-decobot() {
    sc
    d=~/src/mydeco
    export PATH=$ORIGPATH:~/src/scrapy/bin
    export PYTHONPATH=$PYTHONPATH:$d/scraping:$d/toolbox
    cd $d/scraping
    . ~/aws/dev
}

env-asbot() {
    sc
    d=~/src/mydeco
    export PYTHONPATH=$PYTHONPATH:$d/toolbox:$d/autoscraping:~/src/mydeco/scraping
    export DJANGO_SETTINGS_MODULE=autoscraping.ui.settings
    cd $d/autoscraping/autoscraping
    . ~/aws/dev
}

uprcfiles() {
    cd
    hg pull -u rcfiles
    reload
}
