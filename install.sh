#!/usr/bin/env bash

set -eux

SYSTEM="$(uname -m)-linux"
readonly SYSTEM
readonly CONFIG_GIT="https://github.com/uigleki/dotfiles.git"
readonly CONFIG_DIR="$HOME/.config/home-manager"
readonly NIX_PATHS=(
    "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    "$HOME/.nix-profile/etc/profile.d/nix.sh"
)

setup_config() {
    local tmp_dir
    tmp_dir=$(mktemp -d)

    git clone --depth=1 "$CONFIG_GIT" "$tmp_dir"
    cp -r "$tmp_dir/.config" "$HOME"
    rm -rf "$tmp_dir"

    sed -i "s/SYSTEM_PLACEHOLDER/$SYSTEM/g; s/USERNAME_PLACEHOLDER/$USER/g" \
        "$CONFIG_DIR/flake.nix" "$CONFIG_DIR/home.nix"

    sudo find /etc -type f -name "*shrc.backup-before-nix" -delete
}

install_nix() {
    if ! command -v nix >/dev/null 2>&1; then
        printf "n\ny\n" | sh <(curl -L https://nixos.org/nix/install) --daemon
    fi

    for nix_path in "${NIX_PATHS[@]}"; do
        if [ -e "$nix_path" ]; then
            # shellcheck source=/dev/null
            source "$nix_path"
            break
        fi
    done

    nix run nixpkgs#home-manager -- switch -b backup
    nix store gc
}

setup_shell() {
    local zsh_path
    zsh_path=$(command -v zsh)

    if [ "$SHELL" != "$zsh_path" ]; then
        if ! grep -q "^${zsh_path}$" /etc/shells; then
            echo "$zsh_path" | sudo tee -a /etc/shells
        fi

        sudo passwd -d "$USER"
        chsh -s "$zsh_path"
    fi
}

main() {
    setup_config
    install_nix
    setup_shell
}

main
