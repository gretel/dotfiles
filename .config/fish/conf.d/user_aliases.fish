function reload
    echo 'replacing shell...'
    exec fish
end

function reset
    rm -f .config/fish/fishd.* >/dev/null
    exec fish -c 'source .config/fish/config.fish; echo namespace flushed, exiting in 3 seconds...; sleep 3'
end

function tm
    # not already be inside tmux
    test ! $TMUX or return
    # detach any other clients, attach or make new if there isnt one
    command tmux attach -d or command tmux new fish
end

### misc
alias 'top'  'command top -o cpu -s 1'
alias 'ip'   'command curl -4 https://icanhazip.com'
alias 'ip6'  'command curl -6 https://icanhazip.com'

### short to project directory
alias 'prj'  'z prjcts'

### commonly used tools
alias 'de'   'command direnv'
alias 'g'    'command git'
alias 'gs'   'command gitsome'
alias 'h'    'command hub'
alias 'pe'   'command pyenv'
alias 'sl'   'command sublime'

### fasd (additional)
alias 'j'    'z'
alias 'jj'   'zz'

### exa
if command --search exa >/dev/null
    alias 'ls'   'command exa'
    alias 'l'    'command exa -a -lgmH'
    alias 'lg'   'l --git'
    alias 'la'   'l -@'
    alias 'll'   'l -h'
    alias 'llg'  'll --git'
    alias 'l1'   'command exa -1 --group-directories-first'
    alias 'la1'  'l1 -a'
    alias 'le'   'command exa -a -lgH -s extension --group-directories-first'
    alias 'leg'  'le --git'
    alias 'lm'   'command exa -a -lghH -s modified -m'
    alias 'lmg'  'lm --git'
    alias 'lu'   'command exa -a -lghH -s modified -uU'
    alias 'lug'  'lu --git'
    alias 'lt'   'command exa -T'
    alias 'llt'  'command exa -a -lgHh -R -T'
    alias 'tree' 'llt'
    alias 'lr'   'command exa -a -lgHh -R -L 2'
    alias 'lrg'  'command exa -a -lgHh -R -L 2 --git'
    alias 'lrr'  'command exa -a -lgHh -R'
end
