#!/usr/bin/env bash

USERNAME="${USERNAME:-"vscode"}"

set -eux

runuser -l "$USERNAME" <<'EOF'
sh <(curl -L https://nixos.org/nix/install) --no-daemon
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
nix profile install nixpkgs#nil
EOF
