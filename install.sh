#!/usr/bin/env bash

set -euo pipefail

readonly CONFIG_GIT="https://github.com/uigleki/dotfiles.git"
readonly CONFIG_DIR="$HOME/.config/home-manager"
readonly HM_OPTS=(switch -b backup)

clone_and_setup_config() {
    git clone --depth=1 "$CONFIG_GIT" "$CONFIG_DIR"
}

install_nix() {
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
}

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

setup_nix() {
    if ! command_exists nix; then
        install_nix
    fi

    if command_exists home-manager; then
        home-manager "${HM_OPTS[@]}"
    else
        nix run nixpkgs#home-manager -- "${HM_OPTS[@]}"
    fi
}

set_default_shell() {
    local bash_path
    bash_path=$(command -v bash)

    if ! grep -qx "$bash_path" /etc/shells; then
        echo "$bash_path" | sudo tee -a /etc/shells
        chsh -s "$bash_path"
    fi
}

main() {
    # if [[ -f /proc/version ]] && grep -q "Microsoft\|WSL" /proc/version; then
    clone_and_setup_config
    setup_nix
    set_default_shell
}

main
