packages := "shell git nvim helix wezterm starship atuin direnv gh pip ripgrep scripts fonts"

install *pkgs:
    #!/usr/bin/env bash
    for pkg in ${@:-{{packages}}}; do
        if [ -f "packages/$pkg.Brewfile" ]; then
            brew bundle --no-lock --file="packages/$pkg.Brewfile"
        fi
        if [ -d "packages/$pkg" ]; then
            stow -d packages -t ~ "$pkg"
        fi
    done

uninstall *pkgs:
    #!/usr/bin/env bash
    for pkg in ${@:-{{packages}}}; do
        if [ -d "packages/$pkg" ]; then
            stow -d packages -t ~ -D "$pkg"
        fi
    done
