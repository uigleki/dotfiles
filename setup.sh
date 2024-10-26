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

sed -i "s/SYSTEM_PLACEHOLDER/$SYSTEM/g; s/USERNAME_PLACEHOLDER/$USER/g" \
    "$CONFIG_DIR/flake.nix" "$CONFIG_DIR/home.nix"

sudo rm -f /etc/bash.bashrc.backup-before-nix /etc/zsh/zshrc.backup-before-nix

if ! command -v nix >/dev/null 2>&1; then
    sh <(curl -L https://nixos.org/nix/install) --daemon
fi

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

nix run nixpkgs#home-manager -- switch -b backup

command -v zsh | sudo tee -a /etc/shells
chsh -s $(command -v zsh)
