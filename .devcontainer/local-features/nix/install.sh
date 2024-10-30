#!/usr/bin/env bash

USERNAME="${USERNAME:-"vscode"}"

set -eux

su - "$USERNAME" -c "sh <(curl -L https://nixos.org/nix/install) --no-daemon"
