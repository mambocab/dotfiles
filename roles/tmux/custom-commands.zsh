alias tmux="TERM=screen-256color-bce tmux"
alias tmls="tmux list-sessions"
alias tmat="tmux attach-session -d -t"
alias tmhist="tmux capture-pane -S -30000 && tmux save-buffer -"

function tmss {
    tmux list-sessions |
    cut -f 1 -d: |
    selecta |
    xargs tmux switch-client -t
}

function tgo {
    session=${1:-mambocab}
    tmux attach -t $session || tmux new -s $session
}

function tpair {
    touch /tmp/pair
    pairsocket enable
    tmux -S /tmp/pair attach || tmux -S /tmp/pair
}

