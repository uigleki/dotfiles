#!/usr/bin/env bash

set -eux

SYSTEM="$(uname -m)-linux"
readonly SYSTEM
readonly CONFIG_GIT="https://github.com/uigleki/dotfiles.git"
readonly CONFIG_DIR="${HOME}/.config/home-manager"
readonly CONFIG_TOML="${CONFIG_DIR}/config.toml"

clone_and_setup_config() {
    local tmp_dir
    tmp_dir=$(mktemp -d)

    git clone --depth=1 "$CONFIG_GIT" "$tmp_dir"
    cp -r "${tmp_dir}/.config" "$HOME"

    if [ ! -f "$CONFIG_TOML" ]; then
        cp "${tmp_dir}/config.toml" "$CONFIG_TOML"
    fi

    rm -rf "$tmp_dir"

    sed -i "s/SYSTEM_PLACEHOLDER/${SYSTEM}/g; s/USERNAME_PLACEHOLDER/${USER}/g" \
        "${CONFIG_DIR}/flake.nix" "${CONFIG_DIR}/home.nix"
}

install_nix() {
    # shellcheck source=/dev/null
    if ps -p 1 -o comm= | grep -q systemd && [ "$(cat /sys/fs/selinux/enforce 2>/dev/null)" != "1" ]; then
        printf "n\ny\n" | sh <(curl -L https://nixos.org/nix/install) --daemon
        source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    else
        sh <(curl -L https://nixos.org/nix/install) --no-daemon
        source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
    fi
}

setup_nix() {
    command -v nix >/dev/null 2>&1 || install_nix
    nix run nixpkgs#home-manager -- switch -b backup
    nix store gc
}

set_default_shell() {
    local bash_path
    bash_path=$(command -v bash)

    if [ "$SHELL" != "$bash_path" ]; then
        grep -q "^${bash_path}$" /etc/shells || echo "$bash_path" | sudo tee -a /etc/shells
        sudo passwd -d "$USER"
        chsh -s "$bash_path"
    fi
}

main() {
    clone_and_setup_config
    setup_nix
    set_default_shell
}

main
