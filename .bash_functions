#!/bin/sh
reload() {
    . ~/.bashrc
}

# service control with autocompletion
ser() {
    /etc/init.d/$1 $2
}
complete -W "$(ls /etc/init.d/)" ser

kssh() {
    host=$1
    shift
    (telnet $host 20301 >/dev/null 2>&1) &
    ssh $host "$@"
}
complete -F _ssh kssh

redisplay() {
    xrandr --output LVDS1 --auto --output VGA1 --auto --primary --right-of LVDS1
    kill -SIGHUP $(pidof awesome)
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

uptoolbox() {
    cd ~/hg/mydeco/toolbox
    hg pull -u
    cd -
}

sc() {
    export PYTHONPATH=~/hg/scrapy
    export PATH=$ORIGPATH:~/hg/scrapy/bin
    cd ~/hg/scrapy/scrapy
}

scst() {
    export PYTHONPATH=~/hg/scrapy-stable
    export PATH=$ORIGPATH:~/hg/scrapy-stable/bin
    cd ~/hg/scrapy-stable/scrapy
}


env-h() {
    d=~/hg/insophia/scrapinghub
    export PATH=$ORIGPATH:$d/bin
    export PYTHONPATH=$ORIGPYTHONPATH:~/src/Django-1.2.1:~/hg/scrapy:$d
    cd $d
}

env-bh() {
    export PYTHONPATH=$ORIGPYTHONPATH:~/hg/scrapy:~/hg/ido/bh
    cd ~/hg/ido/bh
}

env-jobsbot() {
    export PYTHONPATH=$ORIGPYTHONPATH:~/hg/scrapy:~/hg/halliday/jobsbot
    cd ~/hg/halliday/jobsbot
}

env-travelmatch() {
    export PYTHONPATH=$ORIGPYTHONPATH:~/hg/scrapy:~/hg/travelmatch/travelmatch
    cd ~/hg/travelmatch/travelmatch
}

env-ms() {
    d=~/hg/mydeco
    export PATH=$ORIGPATH:~/hg/scrapy/bin
    export PYTHONPATH=$ORIGPYTHONPATH:~/hg/scrapy:$d/scraping:$d/toolbox
    cd $d/scraping
}

env-msst() {
    d=~/hg/mydeco
    export PATH=$ORIGPATH:~/hg/scrapy/bin
    export PYTHONPATH=$ORIGPYTHONPATH:~/hg/scrapy:$d/scraping:$d/toolbox
    cd $d/scraping
}

env-as() {
    d=~/hg/mydeco
    export PYTHONPATH=$ORIGPYTHONPATH:$d/toolbox:$d/autoscraping:~/hg/scrapy:~/hg/mydeco/scraping
    export DJANGO_SETTINGS_MODULE=autoscraping.ui.settings
    cd $d/autoscraping/autoscraping
}

env-translate() {
    d=~/hg/mydeco
    export PYTHONPATH=$ORIGPYTHONPATH:~/svn/xappy:$d/toolbox:$d/translate
    cd $d/translate
}

env-search() {
#    . ~/virtualenv/mydeco/bin/activate
    d=~/hg/mydeco
    export PYTHONPATH=$ORIGPYTHONPATH:~/svn/xappy/libs/install/usr/lib/python2.6/site-packages:~/svn/xappy:$d/toolbox:$d/search
    cd $d/search
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
}

run-site() {
    env-site $1
    python manage.py runserver 0.0.0.0:8000
}

env-scrapy() {
    export PYTHONPATH=/opt/scrapy:~/scrapy
    export PATH=$ORIGPATH:/opt/scrapy/scrapy/bin
}

env-django() {
    export PYTHONPATH=/opt/django
    export PATH=$ORIGPATH:/opt/django/django/bin
}
