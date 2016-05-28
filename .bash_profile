#!/usr/bin/env bash
#
alias 'g=git'

# exa
if command -v exa >/dev/null; then
    alias 'ls=exa'
    alias 'l=exa -a -lgmH'
    alias 'la=l -@'
    alias 'll=l -h'
    alias 'l1=exa -1 --group-directories-first'
    alias 'la1=l1 -a'
    alias 'le=exa -a -lgH -s extension --group-directories-first'
    alias 'lm=exa -a -lghH -s modified -m'
    alias 'lu=exa -a -lghH -s modified -uU'
    alias 'lt=exa -T'
    alias 'llt=exa -a -lgHh -R -T'
    alias 'tree=llt'
    alias 'lr=exa -a -lgHh -R -L 2'
    alias 'lrr=exa -a -lgHh -R'
fi
