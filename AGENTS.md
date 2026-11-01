# AGENTS.md

## Project

A NixOS and home-manager configuration flake.

## Commands

- Verify an edit: `prek run --files <file>` — the same hooks the commit will run.
- Eval a host without building it: `nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`

## Conventions

- Use Conventional Commits.
- Write comments, documentation, and commit messages in English.
- Only write a code comment to state a constraint the code itself can't show - never to say what the next line does, or why your change is correct; that's you talking to the reviewer, not the next reader.
- Don't use feature flags or backwards-compatibility shims when you can just change the code.
