# Personal Nix Dotfiles

Maximum efficiency, minimum complexity development environment using Nix flakes.

**⚠️ Fork First**: This is my personal configuration. Fork it and modify `hosts/default.nix` before using.

## The Problem

Most development setups are chaotic: scattered config files, broken dependencies, "works on my machine" issues, hours spent on environment setup instead of actual work.

## Why Nix

**Reproducible** • **Declarative** • **Reliable**

One configuration that creates identical environments everywhere - from WSL to cloud servers to bare metal.

## Why This Configuration

Not just minimal - **strategically minimal**. Every choice maximizes productivity while eliminating complexity:

**Complete Control**: Everything defined in code. No hidden system state, no scattered dotfiles, no mysterious breakages.

**Zero Setup Friction**: Clone once, works everywhere. Same keybindings, same tools, same workflow across all machines.

**Modern Toolchain**: Each tool chosen for proven superiority - `fd` over `find`, `rg` over `grep`, `eza` over `ls`. Not trendy, just better.

**Smart Isolation**: Services in containers, projects in flakes. No conflicts, no pollution, no "dependency hell."

**Try Anything**: `,` command lets you test tools instantly without installing. Explore freely, commit nothing.

**Bulletproof Updates**: Atomic changes with instant rollbacks. System updates cannot break your workflow.

**Intelligent Defaults**: Works immediately out of the box, yet infinitely customizable when needed.

## Usage

### For server

```bash
nix run github:nix-community/nixos-anywhere -- --flake ~/.config/dotfiles#nazuna --target-host <user>@<host>
```

### For desktop (Secure Boot + TPM)

```bash
# Connect to WiFi (skip if using ethernet)
nmtui

# Partition disk (will prompt for LUKS encryption password)
nix-shell -p disko --run "sudo disko --mode disko --flake github:uigleki/dotfiles#akira"

# Install system
sudo nixos-install --no-root-passwd --flake github:uigleki/dotfiles#akira

# Reboot, enter BIOS, set Secure Boot to "Setup Mode", then boot
# Lanzaboote will auto-enroll Secure Boot keys and reboot

# After reboot, enroll TPM for automatic LUKS unlock
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 /dev/disk/by-partlabel/disk-main-luks
```

See [post-installation setup](docs/post-install.md) for additional configuration.

### For WSL

```bash
sudo nixos-rebuild switch --flake github:uigleki/dotfiles
```

## Essential Workflow

### System Management

- `, <command>` — Try any tool without installing
- `u` — Update system
- `uu` — Update flake + rebuild
- `nix-collect-garbage -d` — Clean old generations

### Core Tools

- `l` — List files with metadata (`eza`)
- `j <dir>` — Smart directory jump (`zoxide`)
- `fd` — Fast file search
- `rg` / `G` — Fast text search
- `f` — Editor (`helix`)
- `d` — File manager (`yazi`)
- `g` — Git interface (`lazygit`)
- `t` — Terminal multiplexer (`tmux`)

### Navigation Shortcuts

- **Ctrl-t** — File picker
- **Ctrl-r** — Command history
- **Alt-c** — Directory finder

## License

[AGPL-3.0](LICENSE)
