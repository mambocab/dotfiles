# Machine-local customizations (pre): sourced before shared config.
# This allows machine-specific overrides without modifying the shared dotfiles.
[[ -f ~/.local/.zprofile.pre.local ]] && source ~/.local/.zprofile.pre.local

export HOMEBREW_CASK_OPTS="--appdir=~/Applications --require-sha"
eval $(/opt/homebrew/bin/brew shellenv)

# Machine-local customizations (post): sourced after shared config.
# This allows machine-specific additions without modifying the shared dotfiles.
[[ -f ~/.local/.zprofile.post.local ]] && source ~/.local/.zprofile.post.local
