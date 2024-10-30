#!/usr/bin/env bash

USERNAME="${USERNAME:-"vscode"}"

set -eux

runuser -l "$USERNAME" <<'EOF'
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source ~/.nix-profile/etc/profile.d/nix.sh
install -Dm644 <(echo 'experimental-features = nix-command flakes') ~/.config/nix/nix.conf
nix profile install nixpkgs#nil nixpkgs#nixfmt-rfc-style nixpkgs#shellcheck nixpkgs#shfmt
nix store gc
EOF
