alias zshrc="exec $EDITOR ~/.zshrc"
alias vimrc="exec $EDITOR ~/.vimrc"

alias vi="vim"
alias emacs='emacs -nw'

alias ax=chmod a+x

## get public ip address
alias ip="curl http://icanhazip.com/"

## top (via ttscoff)
alias cpu='top -o cpu'
alias mem='top -o rsize' # memory

## ls better (via ttscoff)
alias la="ls -aFG"
alias ld="ls -ld"
alias ll="ls -l"
alias lt='ls -At1 && echo "------Oldest--"'
alias ltr='ls -Art1 && echo "------Newest--"'
alias ls="ls -FG"

# speedtesting alias via http://osxdaily.com/2013/07/31/speed-test-command-line/
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'

# up and down arrow searches for commands starting with current buffer
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

if [ "$OSTYPE" != "darwin" ] ; then
  alias pbcopy='xclip -sel clip'
  alias pbpaste='xclip -sel clip -o'
fi

# zsh builtins
disable r
autoload -U zmv

alias gistp='gist -p'

alias agpy='ag --python'
alias agj='ag --java'

alias love-too=sudo
