# Dotfiles Repository

GNU Stow-managed dotfiles. Each subdirectory of `packages/` is a Stow package whose contents mirror `~/`.

## Structure

```
packages/           # Stow directory (stow -d packages -t ~)
  nvim/             # Package: mirrors ~/.config/nvim/
    .config/nvim/
      init.lua
  shell/            # Package: mirrors ~/.zshrc, ~/.zshenv, etc.
    .zshrc
  git/
    .config/git/
      config
  <name>.Brewfile   # Brew-only packages (no stow directory)
```

## Commands

- `just install` — install all packages (brew dependencies + stow symlinks)
- `just uninstall` — remove all symlinks
- `just install nvim git` — install specific packages
- `just uninstall nvim` — uninstall specific package

Packages with a `packages/<name>.Brewfile` get `brew bundle` run first. Packages with a `packages/<name>/` directory get `stow -d packages -t ~` run.

## Conventions

- direnvrc files don't need a shebang line
- When applying patches, compare against current state first — many changes may already be applied
- Prefer the smallest logically justifiable commits, each scoped to one concern
- Commit freely as part of the workflow — no need to ask first

## Reference

- [house-style.md](house-style.md) — Code, documentation, and git conventions
- [stow.md](stow.md) — GNU Stow reference (terminology, options, tree folding, ignore lists, conflicts)
