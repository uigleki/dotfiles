## 使用方法

```shell
git clone --depth=1 https://gitlab.com/uigleki/dotfiles.git

cd dotfiles
rsync -rt .config .local ~
fish env.fish

sudo fish env.fish
sudo rsync -rt etc /
```
