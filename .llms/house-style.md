# House Style Guide

This document describes the aspirational style and conventions for code, documentation, and git history in this dotfiles repository. Use this when generating code changes, documentation, or commit messages.

## Guiding Principles

1. **Prefer simpler stuff** — avoid over-engineering
2. **Prefer comment-delimited sections over more files** — keep related configurations together rather than splitting into multiple files
3. **Embrace minor inconvenience** — this is not a template for unattended provisioning; manual intervention and verification are acceptable

## Code Style

### Shell Scripts (Bash/Zsh)

**Structure:**
- Use `#!/usr/bin/env bash` (or `zsh`) shebang
- Start bash scripts with `set -euo pipefail` for safety
- Group related commands with blank lines
- Use section comments in ALL_CAPS at line start: `# Section Name.`

**Variables:**
- Use `UPPER_CASE` for constants and script-level configuration
- Use `lowercase` for temporary/loop variables
- Quote variables: `"$var"` not `$var` (unless word splitting is intentional)
- Use `${var}` syntax when adjacent to other text

**Comments:**
- Explain *why*, not just *what*
- For complex logic, comment before the code block
- For external sources, include URLs or attribution
- Mark local modifications: prefix with author initials (e.g., "JW added bashcompinit")

**Example:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Migrate existing dotfiles to stow-managed symlinks.
#
# For each file in the stow packages, if a real (non-symlink) file exists at
# the target location, back it up before running stow.

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%F_%H-%M-%S)"
backed_up=0

# Process each package directory
for pkg_dir in "$DOTFILES_DIR"/packages/*/; do
    pkg="$(basename "$pkg_dir")"
    # ... rest of logic ...
done
```

### Lua

**Structure:**
- Group related configuration in tables
- Use section comments to mark major configuration areas
- Indent table contents consistently

**Comments:**
- Mark sections with `-- Section Name.` comments
- Explain non-obvious configuration choices
- Reference built-in capabilities when applicable

**Example:**
```lua
local wezterm = require "wezterm"
local config = {}

-- Keybindings.
config.keys = {
  {
    mods = "CMD",
    key = ",",
    action = wezterm.action.SpawnCommandInNewTab {
      cwd = os.getenv("WEZTERM_CONFIG_DIR"),
    },
  },
}

-- Text appearance.
config.font_size = 16
config.font = wezterm.font_with_fallback {
  { family = "Iosevka Mambocab", weight = "Bold" },
  "Monaspace Neon",
}
```

## Documentation Style

### Markdown Files

**Structure:**
- Use clear hierarchical headings (# H1, ## H2, ### H3)
- Include a brief purpose statement at the top
- Use code blocks for commands, configuration, and examples
- Use tables for structured information (options, commands, etc.)

**Code Examples:**
- Include syntax highlighting language tags
- Show complete, runnable examples when possible
- Comment non-obvious lines in code blocks

**Tables:**
- Use tables for command reference, configuration options, or structured lists
- Include descriptions alongside options
- Keep table entries concise but clear

**Cross-references:**
- Link between `.llms/` documents using relative paths
- Document relationships between related files/sections
- Example: "See [stow.md](stow.md) for the full GNU Stow reference."

**Example structure:**
```markdown
# Title

Brief description of what this document covers.

## Section

Explanation with inline `code` references.

### Subsection

Content with examples:

\`\`\`bash
echo "example"
\`\`\`

| Option | Description |
|--------|-------------|
| `-n` | Do something |
```

### Inline Documentation in Configuration Files

- Use comment blocks to explain non-obvious settings
- Include external references (URLs, issue numbers) when applicable
- Mark local modifications clearly

**Example:**
```bash
# Use .localrc for SUPER SECRET STUFF that you don't want in your public, versioned repo.
[ -f $HOME/.localrc ] && source $HOME/.localrc

# On slow systems, checking the cached .zcompdump file adds noticable delay to zsh startup.
# This hack restricts it to once a day.
# via https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-3109177
```

## Git Conventions

### Commit Messages

**Subject line (first line):**
- Keep to 50 characters or fewer
- Use imperative mood: "Add feature" not "Added feature"
- Use lowercase (unless starting with a code/file name)
- Do not end with a period
- Focus on *what changed*, not *why*

**Body (if present):**
- Separate subject from body with a blank line
- Explain *why* the change was made
- Wrap at 72 characters
- Use bullet points for multiple reasons
- Include references to related issues if applicable

**Examples:**
```
Update nvim lockfile
```

```
Add support for nvim 0.9 LSP improvements
```

```
Add .llms reference docs for LLM tooling

Summarized GNU Stow manual into .llms/stow.md and added
.llms/README.md with repo structure and conventions. These
serve as the single source of truth for all LLM tools.
```

```
Add stow and just to Brewfile
```

### Commit Scope

- Prefer small, logically scoped commits
- Each commit should address one concern
- Commit as part of the workflow (don't batch for "perfect" commits)
- Use `git commit -v` to view changes while editing the message

### Branch Conventions

- Use lowercase, hyphen-separated names
- Prefix with scope when helpful: `feature/`, `fix/`, `refactor/`
- Keep branch names short and descriptive

## Organization Patterns

### File Structure

- Use comment-delimited sections within files rather than multiple small files
- Group related configurations together
- Place explanatory comments at the section start

### Naming

- Use descriptive, lowercase names for scripts and config files
- Use `UPPER_CASE` for constants in scripts
- Use `lowercase` or `camelCase` for variables (context-dependent)

### Configuration Files

- Include a comment block at the top explaining the file's purpose
- Document non-obvious settings inline
- Group related settings with section comments
- Include version information if applicable

## LLM-Specific Documentation

Documentation for LLM tools should be in the `.llms/` directory and should:

- **Be the single source of truth** — LLM tools reference `.llms/` documents rather than duplicating information inline
- **Be comprehensive** — include enough detail for LLMs to operate effectively
- **Be updateable** — structure to allow easy updates as conventions evolve
- **Be cross-referenced** — link between related documents using relative paths
- **Include examples** — show how to apply the guidance, with real examples from the codebase

Current `.llms/` documents:
- `README.md` — Repository structure and conventions (overview)
- `stow.md` — GNU Stow reference for symlink management
- `house-style.md` — This document; code, documentation, and git conventions
