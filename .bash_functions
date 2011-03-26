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

uptoolbox() {
    cd ~/hg/mydeco/toolbox
    hg pull -u
    cd -
}

sc() {
    export PYTHONPATH=~/hg/scrapy
    export PATH=$ORIGPATH:~/hg/scrapy/bin
    . ~/hg/scrapy/extras/scrapy_bash_completion
    cd ~/hg/scrapy/scrapy
}

scst() {
    export PYTHONPATH=~/hg/scrapy-stable
    export PATH=$ORIGPATH:~/hg/scrapy-stable/bin
    . ~/hg/scrapy-stable/extras/scrapy_bash_completion
    cd ~/hg/scrapy-stable/scrapy
}

projects_dir=~/hg
gp() { # goto project
    sc
    d=$projects_dir/$1
    export PYTHONPATH=$PYTHONPATH:~/hg/sophialib:$d
    cd $d
}
complete -W "$(ls -l $projects_dir | grep ^d | cut -b 47- 2>/dev/null)" gp

env-h() {
    sc
    d=~/hg/insophia/scrapinghub
    export PATH=$PATH:$d/bin
    export PYTHONPATH=$d:$PYTHONPATH
    cd $d
}

aws-h() {
    . ~/aws/shub
}

env-blogbot() {
    sc
    d=~/hg/mydeco
    export PATH=$PATH:~/hg/scrapy/bin
    export PYTHONPATH=$PYTHONPATH:$d/blogbot:$d/toolbox
    cd $d/blogbot
    . ~/aws/dev
}

env-decobot() {
    sc
    d=~/hg/mydeco
    export PATH=$ORIGPATH:~/hg/scrapy/bin
    export PYTHONPATH=$PYTHONPATH:$d/scraping:$d/toolbox
    cd $d/scraping
    . ~/aws/dev
}

env-asbot() {
    sc
    d=~/hg/mydeco
    export PYTHONPATH=$PYTHONPATH:$d/toolbox:$d/autoscraping:~/hg/mydeco/scraping
    export DJANGO_SETTINGS_MODULE=autoscraping.ui.settings
    cd $d/autoscraping/autoscraping
    . ~/aws/dev
}

env-translate() {
    d=~/hg/mydeco
    export PYTHONPATH=$ORIGPYTHONPATH:~/svn/xappy:$d/toolbox:$d/translate
    cd $d/translate
    . ~/aws/dev
}

env-search() {
#    . ~/virtualenv/mydeco/bin/activate
    d=~/hg/mydeco
    export PYTHONPATH=$ORIGPYTHONPATH:~/svn/xappy/libs/install/usr/lib/python2.6/site-packages:~/svn/xappy:$d/toolbox:$d/search
    cd $d/search
    . ~/aws/dev
}

sri() {
    env-search $1
    cd $d/search/mydeco/search/indexer
}

srs() {
    env-search $1
    cd $d/search/mydeco/search/server
}

env-site() {
    export PYTHONPATH=~/src/Django-1.0.2-final:$HOME/svn/pycaptcha
    cd ~/hg/mydeco/site/bydesign
    . ~/aws/dev
}
