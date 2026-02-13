packages := "shell git nvim helix wezterm starship atuin direnv gh pip ripgrep scripts fonts"

_stow mode +pkgs:
    #!/usr/bin/env bash
    stow_args=""
    case "{{mode}}" in
        simulate) stow_args="--simulate -v" ;;
        uninstall) stow_args="-D" ;;
    esac
    for pkg in {{pkgs}}; do
        if [ -f "packages/$pkg.Brewfile" ]; then
            brew bundle --no-lock --file="packages/$pkg.Brewfile"
        fi
        if [ -d "packages/$pkg" ]; then
            stow $stow_args -d packages -t ~ "$pkg"
        fi
    done

install *pkgs:
    just _stow install {{ if pkgs == "" { packages } else { pkgs } }}

simulate *pkgs:
    just _stow simulate {{ if pkgs == "" { packages } else { pkgs } }}

uninstall *pkgs:
    just _stow uninstall {{ if pkgs == "" { packages } else { pkgs } }}
