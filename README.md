# dotfiles

My dotfiles.

## Theory of Operation

This manages dotfiles via the bare-git-repo method. In this method, you simply let your dotfiles live where they're used, in `~`, and version them in a separate, bare, git repository. See `.zshrc` for setup. Credit to @teamsnelgrove for [pointing me to this method][snelgrove] and to HN user StreakyCobra for [sharing the method to begin with][streakycobra].

## Guiding Principles

0. Prefer simpler stuff.
1. Prefer comment-delimited sections over more files. e.g., if you have aliases for interactive sessions, don't break them into `aliases.zsh` and then `source aliases.zsh` from `.zshrc`. Just put them in the `# Functions.` section of your `.zshrc`.
2. Embrace minor inconvenience. `./.config/dotfiles/Brewfile` doesn't mean you'll never need to `brew install` manually when you have to. Put another way: this is not a Terraform template for unattended provisioning of new boxes. This is a folder full of configuration files.

[snelgrove]: https://github.com/teamsnelgrove/dotfiles/tree/2bbfa8d689248874d1265036c8ee2efec7489389#bare-your-sole
[streakycobra]: https://news.ycombinator.com/item?id=11071754
