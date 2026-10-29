# AGENTS.md

## Project

A NixOS and home-manager configuration flake.

## Commands

- Verify an edit: `prek run --files <file>` — the same hooks the commit will run.
- Eval a host without building it: `nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`

## Conventions

- Use Conventional Commits.
- Write comments, documentation, and commit messages in English.
- Comments carry the why the code cannot show.
