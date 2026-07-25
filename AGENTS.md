# Agent Guide

## Project

A NixOS and home-manager configuration flake.

## Commands

- Verify an edit: `prek run --files <file>` — the same hooks the commit will run.
- Eval a host without building it: `nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`

## Conventions

- Use Conventional Commits.
- Write comments, documentation, and commit messages in English.
- Delete unused code completely rather than adding compatibility shims.
- Commit everything staged as one commit; a bundled `flake.lock` diff is intentional.
