#!/usr/bin/env bash

ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
SYSTEM="${ARCH}-${OS}"
CONFIG_GIT="https://gitlab.com/uigleki/dotfiles.git"
CONFIG_DIR="$HOME/.config/home-manager"

set -eux

TMP_DIR=$(mktemp -d)
git clone --depth=1 "$CONFIG_GIT" "$TMP_DIR"
cp -r "$TMP_DIR/.config" "$HOME"
rm -rf "$TMP_DIR"

sed -i "s/SYSTEM_PLACEHOLDER/$SYSTEM/g; s/USERNAME_PLACEHOLDER/$USER/g" \
    "$CONFIG_DIR/flake.nix" "$CONFIG_DIR/home.nix"

sudo find /etc -type f -name "*shrc.backup-before-nix" -delete

if ! command -v nix >/dev/null 2>&1; then
    echo "n\ny\n" | sh <(curl -L https://nixos.org/nix/install) --daemon
fi

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

nix run nixpkgs#home-manager -- switch -b backup

sudo passwd -d $USER

if ! grep -q "$(command -v zsh)" /etc/shells; then
    command -v zsh | sudo tee -a /etc/shells
fi

chsh -s $(command -v zsh)

nix store gc
