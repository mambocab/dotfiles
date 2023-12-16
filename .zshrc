#!/usr/bin/env zsh

# If profiling shell startup, set ZSHRC_PROFILE.
# ZSHRC_PROFILE=1
if [[ -n "$ZSHRC_PROFILE" ]]
then
  set -o xtrace
  zmodload zsh/zprof
fi

if [ ! -f $HOME/.gitconfig_local ]
then
  >&2 echo "Configure your git user settings in $HOME/.gitconfig_local -- see ~/.gitconfig for template."
fi

# Hombrew.
export PATH="/opt/homebrew/bin:$HOME/.local/bin:$PATH:/usr/bin:.dotfiles/bin/"
export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"

# Load direnv.
eval "$(direnv hook zsh)"

# Use .localrc for SUPER SECRET STUFF that you don't want in your public, versioned repo.
[ -f $HOME/.localrc ] && source $HOME/.localrc

# Style.
eval "$(starship init zsh)"

# zsh interaction configuration.
# Up and down search for commands starting with the current buffer, if anything's populated in that buffer.
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
# Not a fan of the "repeat last command" zsh builtin.
disable r
# But I *am* a fan of zmv.
autoload -U zmv
# Deletion with meta keys.
bindkey "^[[3~"  delete-char
bindkey "^[3;5~" delete-char

# Editor defaults.
EDITOR=hx
VISUAL=hx

# Completion.
# Don't autocorrect me.
unsetopt correct
unsetopt correct_all
# On slow systems, checking the cached .zcompdump file to see if it must be 
# regenerated adds a noticable delay to zsh startup.  This little hack restricts 
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
# via https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-3109177
autoload -Uz compinit
() {
  setopt extendedglob local_options

  if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
}
# Smart-ish-case completion -- lowercase letters match uppercase letters but not the other way around.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# If I type `git checkout ta<tab>`, autocomplete with local `task/*` branches, not with the million remote `task/...`
# branches.
export GIT_COMPLETION_CHECKOUT_NO_GUESS=1

# Command editing.
# This is the best. `ctrl-x e` opens a buffer in $EDITOR containing the current contents of the zsh buffer. Edit and
# exit to set the zsh buffer to the results of your editing. Via https://nuclearsquid.com/writings/edit-long-commands
# and https://blog.thecodewhisperer.com/permalink/edit-then-execute
autoload -U edit-command-line
zle -N edit-commandline
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# These command-editing tools can encourage a edit/execute loop for multiline commands. In those cases it's nice to be
# able to use comments.
setopt interactive_comments

# Initialize autojump (aka j).
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# For now, let's experiment with the no-plugins zsh experience.

# Languages.
# Go.
export PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)
# Haskell.
[ -f $HOME/.ghcup/env ] && source $HOME/.ghcup/env

# VS Code.
# ^a, ^e, and ^r should work in the VS Code terminal. The VS Code terminal will silently change editing mode based on
# the contents of EDITOR or VISUAL. We don't want that, so explicitly set it to Emacs mode.
# See https://github.com/microsoft/vscode-docs/issues/5221#issuecomment-1061081538.
bindkey -e
# SSH.
eval `ssh-agent`

# RipGrep.
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgreprc
# Paged and pretty (colors, headers, and line numbers).
function rgp {
  rg -p $"@" | less -RFX
}

# Experimental: dasht, a Dash-inspired docs browser.
# One-time setup:
#   mkdir ~/opt
#   git clone git@github.com:sunaku/dasht.git $DASHT_DIR
export DASHT_DIR=$HOME/opt/dasht
path+="$DASHT_DIR/bin"
fpath+="$DASHT_DIR/etc/zsh/completions"
export MANPATH="$DASHT_DIR/man:$MANPATH"

# Dotfiles management.
#
# One-time setup:
#   git clone --bare git@github.com:mambocab/dotfiles.git ~/.dotfiles
#   dotfiles config --local status.showUntrackedFiles no
# i.e. ~ becomes a worktree managed by git, with the repository itself managed in ~/.dotfiles. And we can run `git status`
# without git complaining that everything in your home dir isn't tracked.
#
# Use `dotfiles` like `git` but scoped to our specific setup.
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# General-purpose aliases.
alias g=git
alias pzf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

# General-purpose functions.
#
# Creates a new scratch directory and cds to it
# via http://ku1ik.com/2012/05/04/scratch-dir.html
function scratch {
  cur_dir="$HOME/scratch"
  new_dir="$HOME/tmp/scratch-`date +'%s'`"
  mkdir -p $new_dir
  ln -nfs $new_dir $cur_dir
  cd $cur_dir
  echo "New scratch dir ready for grinding ;>"
}
#
# mk and cd.
function mkcd { mkdir -p $1 && cd $1 }
#
# Gary Bernhardt's Selecta shortcuts.
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command, followed by a space.
function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    # GRB's original: selected_path=$(fd -t f . | selecta) || return
    selected_path=$(fd -t f . | fzf) || return
    # Escape the selected path, since we're inserting it into a command line.
    # E.g., spaces would cause it to be multiple arguments instead of a single
    # path argument.
    selected_path=$(printf '%q' "$selected_path")
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path "'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget that runs the function.
zle -N insert-selecta-path-in-command-line
# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for...
unsetopt flowcontrol
# ... the newly created widget.
bindkey "^S" "insert-selecta-path-in-command-line"
#
# Via garybernhardt:
# By @ieure; copied from https://gist.github.com/1474072
#
# It finds a file, looking up through parent directories until it finds one.
# Use it like this:
#
#   $ ls .tmux.conf
#   ls: .tmux.conf: No such file or directory
#
#   $ ls `up .tmux.conf`
#   /Users/grb/.tmux.conf
#
#   $ cat `up .tmux.conf`
#   set -g default-terminal "screen-256color"
function up()
{
    local DIR=$PWD
    local TARGET=$1
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR != "/" && echo $DIR/$TARGET
}
#
# go-objdump colorizes and reformats output of `go tool objdump`
# - it inserts an empty line after unconditional control-flow modifying instructions (JMP, RET, UD2)
# - it colors calls/returns in green
# - it colors traps (UD2) in red
# - it colors jumps (both conditional and unconditional) in blue
# - it colors padding/nops in violet
# - it colors the function name in yellow
# - it unindent the function body
function go-objdump() {
  go tool objdump "$@" |
    gsed -E "
      s/^  ([^\t]+)(.*)/\1  \2/
      s,^(TEXT )([^ ]+)(.*),$(tput setaf 3)\\1$(tput bold)\\2$(tput sgr0)$(tput seta
f 3)\\3$(tput sgr0),
      s/((JMP|RET|UD2).*)\$/\1\n/
      s,.*(CALL |RET).*,$(tput setaf 2)&$(tput sgr0),
      s,.*UD2.*,$(tput setaf 1)&$(tput sgr0),
      s,.*J[A-Z]+.*,$(tput setaf 4)&$(tput sgr0),
      s,.*(INT \\\$0x3|NOP).*,$(tput setaf 5)&$(tput sgr0),
    "
}


if [[ -n "$ZSHRC_PROFILE" ]]
then
  zprof
fi
