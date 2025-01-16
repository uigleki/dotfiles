# dotfiles

⚙️ Personal dotfiles and configurations

## ✨ Features

- Effortless setup with home-manager
- Essential CLI tools curated for productivity

## 🚀 Installation

```bash
curl -L github.com/uigleki/dotfiles/raw/main/install.sh | bash
```

After installation:

1. Set your git information in `~/.config/home-manager/config.toml`
2. Run `home-manager switch`

## 📝 Nix Cheatsheet

| Command                                      | Description        |
| -------------------------------------------- | ------------------ |
| `nix shell nixpkgs#<package_name>`           | Try package        |
| `nix profile install nixpkgs#<package_name>` | Install package    |
| `nix profile remove <package_name>`          | Remove package     |
| `nix profile list`                           | List packages      |
| `nix store gc`                               | Clean garbage      |
| `nix-collect-garbage -d`                     | Delete generations |

## 📄 License

[AGPL-3.0](LICENSE)
