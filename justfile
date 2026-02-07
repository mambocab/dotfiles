packages := "shell git nvim helix wezterm starship atuin direnv gh pip ripgrep scripts fonts"

install *pkgs:
    #!/usr/bin/env bash
    for pkg in ${@:-{{packages}}}; do
        if [ -f "packages/$pkg.Brewfile" ]; then
            brew bundle --no-lock --file="packages/$pkg.Brewfile"
        fi
        stow -d packages -t ~ "$pkg"
    done

uninstall *pkgs:
    #!/usr/bin/env bash
    for pkg in ${@:-{{packages}}}; do
        stow -d packages -t ~ -D "$pkg"
    done
