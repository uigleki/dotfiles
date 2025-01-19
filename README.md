# dotfiles

⚙️ Personal dotfiles and configurations

## ✨ Features

- Zero-touch setup with home-manager
- Curated collection of modern CLI tools
- Consistent environment across systems

## 🚀 Installation

```bash
curl -L github.com/uigleki/dotfiles/raw/main/install.sh | bash
```

After installation:

1. Start a new shell session
2. Set your git information in `~/.config/home-manager/config.toml`
3. Run `home-manager switch`

## 📝 Cheatsheet

### Nix Commands

| Command                            | Description        |
| ---------------------------------- | ------------------ |
| `nix shell nixpkgs#<package_name>` | Try package        |
| `nix store gc`                     | Clean garbage      |
| `nix-collect-garbage -d`           | Delete generations |

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
| `ls`        | `eza`      | Directory listing with git status    |
| `find`      | `fd`       | Faster file search                   |
| `grep`      | `ripgrep`  | Pattern search with git integration  |
| `sed`       | `sd`       | Intuitive find & replace             |
| `cd`        | `zoxide`   | Smart directory navigation           |
| `diff`      | `delta`    | Side-by-side diff viewer             |
| `du`        | `dust`     | Tree-based disk usage                |

### Command Shortcuts

| Abbr  | Command                 | Description                  |
| ----- | ----------------------- | ---------------------------- |
| `d`   | `yazi`                  | File manager                 |
| `f`   | `hx`                    | Open in Helix editor         |
| `g`   | `lazygit`               | Git TUI                      |
| `gcl` | `git clone --depth=1`   | Shallow clone repository     |
| `j`   | `z`                     | Jump to frecent directory    |
| `k`   | `btm`                   | System monitor               |
| `l`   | `eza -laF`              | List all files with metadata |
| `lt`  | `eza -TF`               | Display directory tree       |
| `r`   | `rsync`                 | Efficient file transfer      |
| `t`   | `tmux new -A`           | Create/attach tmux session   |
| `u`   | `home-manager switch`   | Apply system changes         |
| `uu`  | `nix flake update && u` | Update flake and rebuild     |
| `G`   | `\| rg`                 | Pipe to ripgrep (anywhere)   |

### Navigation

FZF shortcuts:

- `Ctrl-t` - List files/folders for command completion
- `Ctrl-r` - Search shell command history
- `Alt-c` - Fuzzy change directory

Terminal shortcuts:

- `Ctrl-a` - Move cursor to line start
- `Ctrl-e` - Move cursor to line end
- `Alt-f` - Move cursor forward one word
- `Alt-b` - Move cursor back one word
- `Ctrl-u` - Clear line before cursor
- `Ctrl-k` - Clear line after cursor
- `Ctrl-w` - Delete word before cursor
- `Alt-d` - Delete word after cursor
- `Ctrl-l` - Clear screen
- `Ctrl-c` - Cancel command
- `Ctrl-d` - Exit shell (when line is empty)

## 📄 License

[AGPL-3.0](LICENSE)
