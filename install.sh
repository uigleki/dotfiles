#!/usr/bin/env bash

set -euo pipefail

readonly CONFIG_GIT="https://github.com/uigleki/dotfiles.git"
readonly CONFIG_DIR="${HOME}/.config/home-manager"
readonly CONFIG_TOML="${CONFIG_DIR}/config.toml"
readonly HM_OPTS=(switch -b backup)

TMP_DIR=$(mktemp -d)
readonly TMP_DIR
trap 'rm -rf "$TMP_DIR"' EXIT

clone_and_setup_config() {
    git clone --depth=1 "$CONFIG_GIT" "$TMP_DIR"
    cp -r "${TMP_DIR}/.config" "$HOME"

    cat >"${CONFIG_DIR}/.local" <<EOF
{
  system = "$(uname -m)-linux";
  username = "$USER";
}
EOF

    if [ ! -f "$CONFIG_TOML" ]; then
        cp "${TMP_DIR}/config.toml" "$CONFIG_TOML"
    fi
}

install_nix() {
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
}

setup_nix() {
    if ! command -v nix >/dev/null 2>&1; then
        install_nix
    fi

    if command -v home-manager >/dev/null 2>&1; then
        home-manager "${HM_OPTS[@]}"
    else
        nix run nixpkgs#home-manager -- "${HM_OPTS[@]}"
    fi
}

set_default_shell() {
    local bash_path
    bash_path=$(command -v bash)

    if ! grep -q "^${bash_path}$" /etc/shells; then
        echo "$bash_path" | sudo tee -a /etc/shells
        chsh -s "$bash_path"
    fi
}

main() {
    clone_and_setup_config
    setup_nix
    set_default_shell
}

main
