#!/usr/bin/env bash

USERNAME="${USERNAME:-"vscode"}"

set -eux

runuser -l "$USERNAME" -c "sh <(curl -L https://nixos.org/nix/install) --no-daemon"

runuser -l "$USERNAME" <<'EOF'
install -Dm644 <(echo 'experimental-features = nix-command flakes') ~/.config/nix/nix.conf
nix profile install nixpkgs#nil nixpkgs#nixfmt-rfc-style
EOF
