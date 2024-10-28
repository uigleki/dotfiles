## 安装

```shell
bash <(curl -L github.com/uigleki/dotfiles/raw/main/install.sh)
```

## 基本用法

| 命令                                         | 描述       |
| -------------------------------------------- | ---------- |
| `nix shell nixpkgs#<package_name>`           | 临时使用包 |
| `nix profile install nixpkgs#<package_name>` | 安装包     |
| `nix profile remove <package_name>`          | 卸载包     |
