#!/bin/sh
reload() {
    . ~/.bashrc
}

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

repodir=~/src
p() {
    cd $repodir/$1
}
[ -d $repodir ] && {
    complete -W "$(find ~/src -maxdepth 1 -type d -printf '%f\n')" p
}

# dotfiles git wrapper
alias dotgit="GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ git"
alias dottig="GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ tig"
if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi
complete -o bashdefault -o default -o nospace -F _git dotgit
dotsync (){
    (
        cd ~
        dotfiles pull origin master -u
    )
}
