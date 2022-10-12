## 使用方法

```shell
git clone --depth=1 https://gitlab.com/gleki3/dotfiles.git

rsync -r dotfiles/.config ~
rsync -r dotfiles/.local ~
fish dotfiles/env.fish

sudo fish dotfiles/env.fish
sudo rsync -r dotfiles/etc /
```
