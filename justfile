packages := "shell git nvim helix wezterm starship atuin direnv gh pip ripgrep scripts dasht"

# Packages managed by `just sync` rather than stow (e.g. when symlinks aren't enough).
sync_packages := "fonts"

_stow mode +pkgs:
    #!/usr/bin/env bash
    stow_args=""
    case "{{mode}}" in
        simulate) stow_args="--simulate -v" ;;
        uninstall) stow_args="-D" ;;
    esac
    for pkg in {{pkgs}}; do
        if [ -f "packages/$pkg.Brewfile" ]; then
            brew bundle --file="packages/$pkg.Brewfile"
        fi
        if [ -d "packages/$pkg" ]; then
            stow $stow_args -d packages -t ~ "$pkg"
        fi
    done

# macOS fontd (14+) doesn't follow symlinks, so fonts are copied rather than stowed.
# Opening the files registers them with Font Book without requiring a logout.
_sync_fonts:
    rsync -a packages/fonts/Library/Fonts/ ~/Library/Fonts/
    open ~/Library/Fonts/IosevkaMambocab/*.ttf

macos-defaults:
    ./macos-defaults.sh

install *pkgs:
    just _stow install {{ if pkgs == "" { packages } else { pkgs } }}

simulate *pkgs:
    just _stow simulate {{ if pkgs == "" { packages } else { pkgs } }}

uninstall *pkgs:
    just _stow uninstall {{ if pkgs == "" { packages } else { pkgs } }}

sync *pkgs:
    #!/usr/bin/env bash
    for pkg in {{ if pkgs == "" { sync_packages } else { pkgs } }}; do
        just _sync_$pkg
    done
