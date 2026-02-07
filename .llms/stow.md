# GNU Stow Reference (v2.4.1)

GNU Stow is a symlink farm manager. It takes distinct sets of software/data in separate directories and makes them appear installed in a single directory tree via symlinks.

## Key Terminology

- **Package**: A related collection of files/directories administered as a unit (e.g., `nvim`, `zsh`).
- **Stow directory**: Root directory containing separate packages in subdirectories. Defaults to the current directory.
- **Target directory**: Root of the tree where packages appear to be installed. Defaults to the parent of the stow directory. For dotfiles, this is typically `~`.
- **Package directory**: A subdirectory of the stow directory containing one package's installation image. Its name is the package name.
- **Installation image**: The layout of files/directories a package requires, relative to the target directory. Exists inside the package directory.

Example layout for a dotfiles repo at `~/dotfiles/packages/` (stow dir) targeting `~`:

```
~/dotfiles/packages/         # stow directory
  nvim/                      # package directory (package name: "nvim")
    .config/nvim/init.lua    # installation image
  zsh/
    .zshrc
    .zshenv
```

Running `stow -d ~/dotfiles/packages -t ~ nvim` creates `~/.config/nvim -> ../dotfiles/packages/nvim/.config/nvim`.

## Command Syntax

```
stow [options] [action flag] package ...
```

### Action Flags

| Flag | Long | Description |
|------|------|-------------|
| `-S` | `--stow` | Install packages (default action) |
| `-D` | `--delete` | Unstow (remove symlinks for) packages |
| `-R` | `--restow` | Unstow then re-stow (useful after updating a package) |

Actions can be mixed: `stow -D old-pkg -S new-pkg`.

### Options

| Option | Description |
|--------|-------------|
| `-d dir` / `--dir=dir` | Set stow directory (default: `$STOW_DIR` or `.`) |
| `-t dir` / `--target=dir` | Set target directory (default: parent of stow dir) |
| `--ignore=regexp` | Ignore files matching Perl regex (anchored to end of filename). Repeatable. |
| `--defer=regexp` | Skip stowing if file already stowed by another package (regex anchored to start of relative path). Repeatable. |
| `--override=regexp` | Force stow even if file is owned by another stow package (regex anchored to start of relative path). Repeatable. |
| `--dotfiles` | Replace `dot-` prefix with `.` in file/directory names |
| `--no-folding` | Disable tree folding/refolding; always create real directories |
| `--adopt` | Move existing target files into the package directory (WARNING: modifies stow dir contents) |
| `-n` / `--no` / `--simulate` | Dry run; show what would happen without modifying filesystem |
| `-v[=n]` / `--verbose[=n]` | Verbosity 0-5 (default 0; `-v` increments by 1) |
| `-p` / `--compat` | Scan whole target tree when unstowing (legacy behavior) |
| `-V` / `--version` | Show version |
| `-h` / `--help` | Show help |

### Environment Variables

| Variable | Description |
|----------|-------------|
| `STOW_DIR` | Default stow directory if `-d` not specified |

## Core Concepts

### Tree Folding

Stow minimizes symlinks. If it can create a single symlink to an entire subtree, it will, rather than creating the directory and individual file symlinks. For example, if `~/.config/nvim/` doesn't exist, Stow creates one symlink `~/.config/nvim -> ../../dotfiles/packages/nvim/.config/nvim` instead of individual file links.

### Tree Unfolding

When a second package needs a directory that's currently a folded symlink, Stow "unfolds" it: removes the symlink, creates a real directory, then creates individual symlinks for both packages inside it.

### Tree Refolding

When unstowing, if a directory ends up containing symlinks to only one package, Stow refolds it back into a single symlink. Disabled by `--no-folding`.

### Ownership

Stow "owns" symlinks in the target tree that point into a stow package, and directories that contain only Stow-owned symlinks. Stow never deletes anything it doesn't own.

### Conflicts

A conflict occurs when Stow needs to create a symlink/directory but a non-Stow-owned file already exists there. Stow uses a two-phase algorithm (since v2.0): it scans for all conflicts first, and if any are found, it aborts without modifying anything. Use `--adopt` to resolve conflicts by absorbing existing files into the package.

## Ignore Lists

Stow checks for ignore lists in this priority order (first found wins):

1. `.stow-local-ignore` in the package's top-level directory
2. `~/.stow-global-ignore`
3. Built-in default list

### Default Ignore Patterns

```
RCS, .+,v, CVS, \.\#.+, \.cvsignore, \.svn, _darcs, \.hg,
\.git, \.gitignore, \.gitmodules, .+~, \#.*\#, ^/README.*, ^/LICENSE.*, ^/COPYING
```

### Ignore List Syntax

- One Perl regex per line
- Lines starting with `#` are comments
- Patterns containing `/` are matched against the full relative path (prefixed with `/`)
- Patterns without `/` are matched against the basename only
- All patterns are anchored (exact match, not substring)
- `.stow-local-ignore` itself is always ignored

## Resource Files

Default options can be set in `.stowrc` (current directory) or `~/.stowrc`. Both are loaded (current dir first). Options are prepended to the command line. Action flags (`-D`, `-S`, `-R`) and package names in resource files are ignored. Environment variables (`$VAR` or `${VAR}`) and `~` are expanded in path values.

## --dotfiles Mode

When enabled, files/directories prefixed with `dot-` in the package directory are stowed with a `.` prefix instead. Example: `dot-bashrc` becomes `.bashrc`. Files without the `dot-` prefix are stowed normally.

## --adopt Workflow

Useful for bootstrapping a stow-managed dotfiles repo with version control:

1. Create the package directory structure with placeholder files
2. Run `stow --adopt package` to move existing target files into the package
3. Use `git diff` to review what changed
4. Commit or discard as needed

## Multiple Stow Directories

Create a `.stow` file in each stow directory to mark it. This prevents Stow from treating another stow directory's contents as things it owns.

## Target Maintenance (chkstow)

```
chkstow [options]
```

| Option | Description |
|--------|-------------|
| `-t dir` | Set target directory |
| `-b` / `--badlinks` | Find dangling symlinks |
| `-a` / `--aliens` | Find non-symlink files (that Stow doesn't own) |
| `-l` / `--list` | List all symlinks and their target packages |

## Common Dotfiles Usage Patterns

```bash
# Install a package (from stow directory)
cd ~/dotfiles/packages && stow -t ~ nvim

# Install with explicit paths
stow -d ~/dotfiles/packages -t ~ nvim

# Unstow a package
stow -D -d ~/dotfiles/packages -t ~ nvim

# Re-stow after updating package contents
stow -R -d ~/dotfiles/packages -t ~ nvim

# Dry run to preview changes
stow -n -v -d ~/dotfiles/packages -t ~ nvim

# Adopt existing files into a package
stow --adopt -d ~/dotfiles/packages -t ~ nvim

# Install all packages
cd ~/dotfiles/packages && stow -t ~ */
```
