#!/usr/bin/env zsh

# Load direnv.
eval "$(direnv hook zsh)"

if [[ -n "$ZSHRC_PROFILE" ]]
then
  set -o xtrace
  zmodload zsh/zprof
fi
  
# Use .localrc for SUPER SECRET STUFF that you don't want in your public, versioned repo.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# Style.
eval "$(starship init zsh)"

# Hombrew -> zsh.
export PATH="/opt/homebrew/bin:$PATH:/usr/bin:.dotfiles/bin/"
export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"

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

  if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
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

# Use /opt/homebrew rather than brew --prefix -- so slow!
. /opt/homebrew/etc/profile.d/autojump.sh

# For now, let's experiment with the no-plugins zsh experience.

# Languages.
# Python.
# Load pyenv lazily.
# via https://github.com/davidparsson/zsh-pyenv-lazy/blob/master/pyenv-lazy.plugin.zsh
export PYENV_ROOT="~/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"
export PYENV_SHELL=zsh
function pyenv() {
  unset -f pyenv
  eval "$(pyenv init -)"
  pyenv $@
}
# Go.
export PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)
# Haskell.
[ -f "~/.ghcup/env" ] && source "~/.ghcup/env"


# VS Code.
# ^a, ^e, and ^r should work in the VS Code terminal. The VS Code terminal will silently change editing mode based on
# the contents of EDITOR or VISUAL. We don't want that, so explicitly set it to Emacs mode.
# See https://github.com/microsoft/vscode-docs/issues/5221#issuecomment-1061081538.
bindkey -e
# SSH.
eval `ssh-agent`

# RipGrep.
export RIPGREP_CONFIG_PATH=~/.config/ripgreprc
# Paged and pretty (colors, headers, and line numbers).
function rgp {
  rg -p $"@" | less -RFX
}

# Experimental: dasht, a Dash-inspired docs browser.
# One-time setup: git clone git@github.com:sunaku/dasth.git $DASHT_DIR
export DASHT_DIR=~/opt/dasht
path+="$DASHT_DIR/bin"
fpath+="$DASHT_DIR/etc/zsh/completions"
export MANPATH="$DASHT_DIR/man:$MANPATH"

# Dotfiles management.
# One-time setup:
#   git clone --bare git@github.com:mambocab/dotfiles.git $DOTFILES_DIR
#   dotfiles config --local status.showUntrackedFiles no
# i.e. ~ becomes a worktree managed by git, with the repository itself managed in $DOTFILES_DIR. And we can run `git status`
# without git complaining that everything in your home dir isn't tracked.
export DOTFILES_DIR=~/.config/dotfiles
# Use `dotfiles` like `git` but scoped to our specific setup.
alias dotfiles='/usr/bin/git --git-dir=~/.dotfiles/ --work-tree=~'

if [[ -n "$ZSHRC_PROFILE" ]]
then
  zprof
fi
