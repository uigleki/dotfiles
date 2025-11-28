# AGENTS.md

NixOS/Home-Manager flake. Supports full NixOS and standalone home-manager (WSL, non-NixOS).

## Hosts

- **nazuna** - ARM server
- **akira** - WSL
- **mayuri** - Desktop GUI
- **kurisu** - Standalone home-manager

User identity: `hosts/default.nix` → `baseUser`

## Structure

```
flake.nix → hosts/default.nix
  ├─ NixOS: nixos/* + home/*
  └─ Standalone: home/* (imports nixos/nix.nix conditionally)
```

- `home/` → user config (all setups)
- `nixos/` → system config (NixOS only)

## Commands

```bash
nix fmt <file>  # Format (required before commit)
nix flake check # Validate
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
```

**Preview only** (never deploy directly):

```bash
sudo nixos-rebuild dry-run --flake .
home-manager switch --dry-run --flake .
```

## Code Style

- Self-documenting code; comments only for "why", not "what"
- Single-responsibility modules; avoid over-abstraction
- Custom options: `myModules.<name>` prefix
- Default-enable: `lib.mkEnableOption "..." // { default = true; }`
- Standalone check: `osConfig ? null` or `osConfig == null`

## Critical Rules

1. **Never modify stateVersion** ("25.05") — triggers breaking migrations
2. **Never deploy** — use `--dry-run` only
3. **Keep standalone compatibility** — `home/` must work with `osConfig == null`

## New Host

1. Extend `baseUser` in `hosts/default.nix`
2. Add to `nixosConfigurations` or `homeConfigurations`
3. Create `hosts/<name>/default.nix`
