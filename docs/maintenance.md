# 维护手册：安装、更新、排障、扩展

## 安装与重装

```sh
git clone https://github.com/buptweixin/mydotfiles.git ~/.dotfiles
cd ~/.dotfiles && script/bootstrap
```

bootstrap 可重复运行，但并非每一步都是严格幂等：

1. 链接所有 `*.symlink` 到 `~`（已正确链接的自动跳过，冲突交互式备份）
2. 首次生成 `git/gitconfig.local.symlink`（询问 git 身份）
3. `script/install`：装/配 Homebrew → `brew bundle` → 跑各 topic 的 install.sh；
   tmux 配置覆盖前会生成带时间戳的备份

**只重装某个 topic**：`script/install herdr tmux ghostty ...`

## 更新

| 内容 | 命令 |
|------|------|
| brew 包（gh/bat/tmux/zoxide/herdr…） | `brew bundle --file=~/.dotfiles/Brewfile`（在仓库根） |
| ghostty | cask 自动更新（`auto_updates`） |
| zsh 插件 | 编辑 `zsh/plugins.lock` 中的完整 commit SHA 后运行 `script/install zsh` |
| herdr | `herdr update` |
| nvim 插件 | nvim 内 `:Lazy sync` |

Homebrew 是滚动发行的包管理器；Brewfile 记录需要的包，不是严格的版本
锁定文件。更新 zsh 插件时只按上述步骤手动调整并安装，不承诺自动升级。

## 启动缓存机制

`~/.cache/dotfiles/` 下缓存了会拖慢启动的东西（`brew shellenv`、
`starship init`、`zoxide init` 的输出，均 zcompile）：
**工具升级后自动重建**（缓存比二进制旧即重生成）。手动重建：

```sh
rm -rf ~/.cache/dotfiles && exec zsh -l
```

## 排障

| 症状 | 诊断与处置 |
|------|-----------|
| zsh 启动慢 | zshrc 首行临时加 `zmodload zsh/zprof`，`zsh -i -c exit` 看热点；再查 `~/.cache/dotfiles` 是否失效 |
| PATH 不对 | 看 `system/path.zsh`（第一阶段加载）与 `homebrew/path.zsh` 的缓存；`echo $path` 逐项核对 |
| 别名/函数没生效 | 文件名不符约定（`*.zsh`、`path.zsh`、`completion.zsh`）；跑 `reload!` |
| 补全缺失 | 确认已运行 `script/install zsh`；检查 `~/.local/share/dotfiles/zsh/plugins/zsh-completions/src`，必要时重跑安装器 |
| ghostty 配置疑虑 | `ghostty +validate-config`；`ghostty +show-config` 看生效值 |
| tmux 里环境变量旧 | `prefix+E` 刷新（renew_env.sh） |
| tmux 复制不进剪贴板 | 确认在 ghostty/iTerm 类支持 OSC52 的终端里；`set-clipboard external` 已配 |
| herdr 配置不生效 | `herdr server reload-config`；看 `~/.config/herdr/herdr-server.log` |
| gh 推送被拒（scope） | `gh auth status` 看 scopes；`gh auth refresh -s workflow` 等 |
| brew 下载慢 | TUNA 镜像默认开启；海外网络可 `DOTFILES_DISABLE_TUNA_HOMEBREW=1` |

## 如何添加新 topic

建一个目录，按约定放文件，zshrc 与 bootstrap 自动发现：

```
mytopic/
  path.zsh        # 可选：PATH/环境（最先加载）
  aliases.zsh     # 可选：任意 *.zsh 中段加载
  completion.zsh  # 可选：compinit 之后加载
  install.sh      # 可选：script/install 会执行
  *.symlink       # 可选：链接为 ~/.<名字>
```

install.sh 模板照抄 `ghostty/install.sh`（`set -euo pipefail` +
已链接则跳过 + 时间戳备份）。CLI 工具由 Brewfile/Homebrew 安装；zsh
插件由 `zsh/install.sh` 按 `zsh/plugins.lock` 安装并固定完整 commit。

## 质量门禁

- CI（`.github/workflows/lint.yml`）对 shell 脚本跑 shellcheck，并对全部
  `*.zsh` 与 `zsh/zshrc.symlink` 做 `zsh -n`
- 本地提交前自查：`bash -n` / `zsh -n`，或直接看 CI

## 不变的约定

- 私密内容只进 `~/.localrc`（shell）和 `gitconfig.local.symlink`（git）
- 提交身份用私人邮箱；公共配置文件里不出现任何身份信息
- 别名不要重复定义（`gl`/`gp` 的教训：后定义静默覆盖前面的语义）
