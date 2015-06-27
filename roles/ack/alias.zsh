if (( ! $+commands[ack] )) ; then
  if (( $+commands[ack-grep] )) ; then
    alias ack=ack-grep
  fi
fi

alias ackpy='ack --type=python '
alias pyack='ack --type=python '
