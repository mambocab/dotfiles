# dasht

[dasht](https://github.com/sunaku/dasht) is a collection of shell scripts for searching, browsing, and managing API documentation offline, in the terminal or browser. The name is a portmanteau of [Dash](https://kapeli.com/dash) and "t" for terminal. It uses Dash-compatible docsets (200+).

## Installation

Available via Homebrew (`brew install dasht`), which handles dasht and its dependencies. Managed in this repo via `packages/dasht.Brewfile`.

## Key Commands

| Command | Description |
|---------|-------------|
| `dasht PATTERN` | Search installed docsets from the terminal |
| `dasht-docsets-install NAME` | Download and install a docset |
| `dasht-docsets-remove NAME` | Remove an installed docset |
| `dasht-docsets` | List installed docsets |
| `dasht-server` | Start a local search engine for browser-based browsing |

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DASHT_DOCSETS_DIR` | `$XDG_DATA_HOME/dasht/docsets/` or `~/.local/share/dasht/docsets/` | Where docsets are stored |
| `DASHT_CACHE_DIR` | `$XDG_CACHE_HOME/dasht/` or `~/.cache/dasht/` | Where download link caches are stored |

## Dependencies

Required: `sqlite3`. Optional: `wget` (downloading docsets), `w3m` (terminal display), `socat` + `gawk` (dasht-server).

## Docset Storage

Docsets can be large. They are stored outside this repo at `~/.local/share/dasht/docsets/` by default and are not managed by Stow.
