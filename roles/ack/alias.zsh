if (( ! $+commands[ack] )) ; then
  if (( $+commands[ack-grep] )) ; then
    alias ack=ack-grep
  fi
fi
