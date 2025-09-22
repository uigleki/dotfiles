# Personal Nix Dotfiles

🌸 Declarative cross-platform development environment using Nix flakes.

**⚠️ Fork First**: This is my personal configuration. Fork it and modify `hosts/default.nix` before using.

## ✨ Why Nix?

**Reproducible** • **Declarative** • **Reliable**

Simple configuration that works the same everywhere - from WSL to cloud servers.

## 🎯 Philosophy

- **Minimal by design**: Only install what you need, try tools with `,` (comma)
- **Container-first**: Services run in containers, keep the system clean
- **Modern toolchain**: `fd`, `rg`, `bat` instead of traditional tools
- **Project isolation**: Use direnv + flakes for project dependencies

## 🚀 Usage

### For server:

```bash
nix run github:nix-community/nixos-anywhere -- --flake ~/.config/home-manager#nazuna --target-host <user>@<host>
```

### For WSL:

```bash
git clone --depth=1 https://github.com/uigleki/dotfiles.git ~/.config/home-manager
sudo nixos-rebuild switch --experimental-features 'nix-command flakes' --flake ~/.config/home-manager#nixos
```

## 📝 Cheatsheet

### System Management

| Command                  | Description                    |
| ------------------------ | ------------------------------ |
| `, <command>`            | Try command without installing |
| `nix-collect-garbage -d` | Delete old generations         |

### Core Tools

| Traditional | Modern           | Description                   |
| ----------- | ---------------- | ----------------------------- |
| `ls`        | `l` (`eza -laF`) | List files with metadata      |
| `cd`        | `j` (`zoxide`)   | Smart directory jump          |
| `find`      | `fd`             | Fast file search              |
| `grep`      | `rg` / `G`       | Fast text search              |
| `cat`       | `bat`            | File viewer with highlighting |
| `man`       | `tldr`           | Practical examples            |
| `top`       | `k` (`bottom`)   | System monitor                |
| `du`        | `dust`           | Disk usage tree               |

### Quick Actions

| Key  | Command       | Description          |
| ---- | ------------- | -------------------- |
| `f`  | `helix`       | Open editor          |
| `d`  | `yazi`        | File manager         |
| `g`  | `lazygit`     | Git interface        |
| `t`  | `tmux new -A` | Terminal multiplexer |
| `dl` | `aria2c`      | Download files       |
| `r`  | `rsync -rthP` | Sync files           |

### Navigation Shortcuts

- **Ctrl-t** — File/folder picker
- **Ctrl-r** — Command history search
- **Alt-c** — Change directory fuzzy finder
- **Ctrl-l** — Clear screen

## 📄 License

[AGPL-3.0](LICENSE)
