# Project Context

## Overview

Personal NixOS dotfiles for reproducible, declarative development environments. The goal is **maximum efficiency with minimum complexity** - a strategically minimal configuration that works identically across WSL, cloud servers, and bare metal.

## Tech Stack

- **Nix Flakes** – nixpkgs 25.11 stable + unstable channel
- **home-manager** (release-25.11) – user environment management
- **NixOS-WSL** – Windows Subsystem for Linux integration
- **Disko** – declarative disk partitioning
- **nix-index-database** – fast command-not-found with comma command
- **git-hooks.nix** – pre-commit hook management

### Core CLI Tools

- Zsh with Starship prompt, zoxide for smart jumping
- Helix editor, Yazi file manager, lazygit, tmux
- fd, ripgrep, fzf, eza, bat, bottom

### Development

- Node.js 24 with pnpm
- Python via uv
- direnv with nix-direnv for per-project environments

## Structure

Modular layered architecture:

- `home/` – user-level configs (core.nix → dev.nix/gui.nix)
- `nixos/` – system-level configs
- `hosts/` – per-machine configurations (kurisu, mayuri, nazuna, akira)

Higher layers import from lower layers. Host configs are the top layer.

## Best Practices

- Use nixfmt-rfc-style (the new standard formatter, not nixfmt or alejandra)
- All flake inputs should follow nixpkgs to avoid duplication
- Prefer home-manager programs options over raw config files when available

## Conventions

- Each logical component (git, tmux, helix) in separate .nix file
- Inline comments for non-obvious configuration choices
- Conventional Commits: `type(scope): description`

## Domain Context

- All configs are Nix flakes for reproducibility
- nixos/ for system-level, home/ for user-level

## Testing

- Pre-commit hooks: deadnix, nil, nixfmt-rfc-style, statix, prettier, markdownlint
- Build validation: `nix flake check`
