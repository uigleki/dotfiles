#!/usr/bin/env bash
set -e

ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
SYSTEM="${ARCH}-${OS}"
GIT_NAME="dotfiles"
CONFIG_GIT="https://gitlab.com/uigleki/$GIT_NAME.git"
CONFIG_DIR="$HOME/.config/home-manager"

git clone --depth=1 "$CONFIG_GIT"
cp -r "$GIT_NAME/.config" "$HOME"
rm -rf "$GIT_NAME"

sh <(curl -L https://nixos.org/nix/install) --daemon

echo "System: $SYSTEM"
echo "User: $USER"

sed -i -e "s/SYSTEM_PLACEHOLDER/$SYSTEM/g" \
       -e "s/USERNAME_PLACEHOLDER/$USER/g" \
       "$CONFIG_DIR/flake.nix" \
       "$CONFIG_DIR/home.nix"

nix run nixpkgs#home-manager -- switch -b backup
