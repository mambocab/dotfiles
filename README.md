# dotfiles

My dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
brew bundle
git clone git@github.com:mambocab/dotfiles.git ~/dotfiles
cd ~/dotfiles
scripts/migrate        # backs up existing files, then stows everything
```

Or, if starting fresh (no existing dotfiles to preserve):

```bash
just install
```

Install individual packages:

```bash
just install nvim
```

Unlink everything:

```bash
just uninstall
```

## Layout

```
~/dotfiles/
├── packages/           # stow packages — each mirrors ~/
│   ├── shell/
│   ├── git/
│   ├── nvim/
│   ├── ...
├── scripts/            # repo utilities (not stowed)
│   └── migrate         # safe migration from non-stow setups
├── Brewfile
├── justfile
└── README.md
```

## Guiding Principles

0. Prefer simpler stuff.
1. Prefer comment-delimited sections over more files. e.g., if you have aliases for interactive sessions, don't break them into `aliases.zsh` and then `source aliases.zsh` from `.zshrc`. Just put them in the `# Functions.` section of your `.zshrc`.
2. Embrace minor inconvenience. `Brewfile` doesn't mean you'll never need to `brew install` manually when you have to. Put another way: this is not a Terraform template for unattended provisioning of new boxes. This is a folder full of configuration files.

## Packages

| Package | Contents |
|---------|----------|
| `shell` | `.zshrc`, `.zprofile` |
| `git` | `.config/git/config`, `.config/git/ignore` |
| `nvim` | `.config/nvim/init.lua`, lazy-lock |
| `helix` | `.config/helix/config.toml`, languages |
| `wezterm` | `.config/wezterm/wezterm.lua`, colors |
| `starship` | `.config/starship.toml` |
| `atuin` | `.config/atuin/config.toml` |
| `direnv` | `.config/direnv/direnvrc` |
| `gh` | `.config/gh/config.yml` |
| `pip` | `.config/pip/pip.conf` |
| `ripgrep` | `.config/ripgreprc` |
| `scripts` | `.local/bin/gp`, `git-delete-merged-to`, `npmx` |
| `fonts` | `.fonts/iosevka/` build config |
