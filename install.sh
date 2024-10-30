#!/usr/bin/env bash

set -eux

SYSTEM="$(uname -m)-linux"
readonly SYSTEM
readonly CONFIG_GIT="https://github.com/uigleki/dotfiles.git"
readonly CONFIG_DIR="$HOME/.config/home-manager"

clone_and_setup_config() {
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    git clone --depth=1 "$CONFIG_GIT" "$tmp_dir"
    cp -r "$tmp_dir/.config" "$HOME"
    sed -i "s/SYSTEM_PLACEHOLDER/$SYSTEM/g; s/USERNAME_PLACEHOLDER/$USER/g" \
        "$CONFIG_DIR/flake.nix" "$CONFIG_DIR/home.nix"
}

install_nix() {
    local install_cmd="sh <(curl -L https://nixos.org/nix/install)"
    if ps -p 1 -o comm= | grep -q systemd && [ "$(cat /sys/fs/selinux/enforce 2>/dev/null)" != "1" ]; then
        printf "n\ny\n" | $install_cmd --daemon
        source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    else
        $install_cmd --no-daemon
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
}

setup_nix() {
    command -v nix >/dev/null 2>&1 || install_nix
    nix run nixpkgs#home-manager -- switch -b backup
    nix store gc
}

set_default_shell() {
    local zsh_path
    zsh_path=$(command -v zsh)

    if [ "$SHELL" != "$zsh_path" ]; then
        grep -q "^${zsh_path}$" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells
        sudo passwd -d "$USER"
        chsh -s "$zsh_path"
    fi
}

main() {
    clone_and_setup_config
    setup_nix
    set_default_shell
}

main
