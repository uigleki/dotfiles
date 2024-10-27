#!/usr/bin/env bash

SYSTEM="$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')"
CONFIG_GIT="https://gitlab.com/uigleki/dotfiles.git"
CONFIG_DIR="$HOME/.config/home-manager"

set -eux

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
        echo "n\ny\n" | sh <(curl -L https://nixos.org/nix/install) --daemon
    fi

    NIX_PATHS=(
        "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
        "$HOME/.nix-profile/etc/profile.d/nix.sh"
    )
    for nix_path in "${NIX_PATHS[@]}"; do
        if [ -e "$nix_path" ]; then
            source "$nix_path"
            break
        fi
    done

    nix run nixpkgs#home-manager -- switch -b backup
    nix store gc
}

setup_shell() {
    sudo passwd -d "$USER"
    local zsh_path
    zsh_path=$(command -v zsh)
    if ! grep -q "$zsh_path" /etc/shells; then
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi
    chsh -s "$zsh_path"
}

main() {
    setup_config
    install_nix
    setup_shell
}

main
