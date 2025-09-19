# Personal Nix Configuration

🌸 My personal NixOS and Home Manager configuration flake

**⚠️ Warning**: This is my personal configuration repository. If you want to use it, please fork it and modify the personal information in `hosts/default.nix` (username, email, SSH keys, etc.) to match your own setup.

## ✨ Features

- Declarative system and user configuration with Nix flakes
- Home Manager for dotfiles and user environment
- Modern CLI tools and development environment
- Consistent setup across different machines

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

### Nix Commands

| Command                  | Description        |
| ------------------------ | ------------------ |
| `, <command>`            | Try command        |
| `nix store gc`           | Clean garbage      |
| `nix-collect-garbage -d` | Delete generations |

### Core Tools

| Category        | Tool     | Description              |
| --------------- | -------- | ------------------------ |
| Shell           | `fish`   | Modern interactive shell |
| Editor          | `helix`  | Modal text editor        |
| File Management | `yazi`   | Terminal file manager    |
| System Monitor  | `bottom` | Resource viewer          |

### Modern Alternatives

| Traditional | Modern     | Description                          |
| ----------- | ---------- | ------------------------------------ |
| `man`       | `tealdeer` | Practical command examples           |
| `cat`       | `bat`      | File viewer with syntax highlighting |
| `ls`        | `eza`      | Modern file & directory listing      |
| `find`      | `fd`       | Faster file search                   |
| `grep`      | `ripgrep`  | Fast recursive pattern search        |
| `sed`       | `sd`       | Intuitive find & replace             |
| `cd`        | `zoxide`   | Smart directory navigation           |
| `diff`      | `delta`    | Syntax-highlighting diff viewer      |
| `du`        | `dust`     | Tree-based disk usage                |

### Command Shortcuts

| Abbr  | Command                   | Description                  |
| ----- | ------------------------- | ---------------------------- |
| `bt`  | `aria2c --bt-tracker=...` | BT download with trackers    |
| `d`   | `yazi`                    | File manager                 |
| `dl`  | `aria2c`                  | Download files with aria2c   |
| `f`   | `hx`                      | Open in Helix editor         |
| `g`   | `lazygit`                 | Git TUI                      |
| `gcl` | `git clone --depth=1`     | Shallow clone repository     |
| `gp`  | `git pull`                | Pull git repository          |
| `j`   | `z`                       | Jump to frecent directory    |
| `k`   | `btm`                     | System monitor               |
| `l`   | `eza -laF`                | List all files with metadata |
| `lt`  | `eza -TF`                 | Display directory tree       |
| `r`   | `rsync -rthP`             | Efficient file transfer      |
| `t`   | `tmux new -A`             | Create/attach tmux session   |
| `u`   | `nh home switch`          | Apply system changes         |
| `uu`  | `nix flake update && u`   | Update flake and rebuild     |
| `G`   | `\| rg`                   | Pipe to ripgrep (anywhere)   |

### Navigation

FZF shortcuts:

- `Ctrl-t` - List files/folders for command completion
- `Ctrl-r` - Search shell command history
- `Alt-c` - Fuzzy change directory

Terminal shortcuts:

- `Ctrl-a` / `Ctrl-e` - Move cursor to line start/end
- `Alt-f` / `Alt-b` - Move cursor forward/backward one word
- `Ctrl-u` / `Ctrl-k` - Clear line before/after cursor
- `Ctrl-w` / `Alt-d` - Delete word before/after cursor
- `Ctrl-l` - Clear screen
- `Ctrl-c` - Cancel command
- `Ctrl-d` - Exit shell (when line is empty)

## 📄 License

[AGPL-3.0](LICENSE)
