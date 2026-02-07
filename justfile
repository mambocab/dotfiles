packages := "shell git nvim helix wezterm starship atuin direnv gh pip ripgrep scripts fonts"

install:
    #!/usr/bin/env bash
    for pkg in {{packages}}; do stow -d packages -t ~ "$pkg"; done

uninstall:
    #!/usr/bin/env bash
    for pkg in {{packages}}; do stow -d packages -t ~ -D "$pkg"; done
