# zsh 日常武器库

加载机制：`zsh/zshrc.symlink` 按约定收集所有 topic 的 `*.zsh`——
`path.zsh` 最先（PATH/环境）、其余居中、`completion.zsh` 最后（compinit 之后）。
CLI 工具由 Brewfile/Homebrew 安装；zsh 插件由显式 `zsh/install.sh` 从
`zsh/plugins.lock` 安装，并固定到完整 commit。zsh 启动只加载本地依赖，
不会联网或安装。

## 别名精选

### git（注意两个带语义的）

| 别名 | 展开 | 备注 |
|------|------|------|
| `gl` | `git pull --prune` | **自动清理已删除的远端分支** |
| `gp` | `git push origin HEAD` | **推当前分支，不用打全名** |
| `g` / `gd` / `gb` / `gco` / `gcount` | git / diff / branch / checkout / shortlog -sn | |
| 完整列表 | `git/aliases.zsh` | OMZ 全家 + 自定义 |

### 系统 / 文件

| 别名 | 效果 |
|------|------|
| `cat` | `bat`（语法高亮；`/bin/cat` 需要时写全路径） |
| `v` | `nvim` |
| `ll` / `l` / `la` / `ls` | exa 系列（`ls` 自带 git 状态 + 目录优先） |
| `reload!` / `sz` | 重载 zshrc |
| `cls` | 清屏 |
| `rl <path>` | realpath |
| `pubkey` | 公钥进剪贴板 |
| `rsync-copy/move/update/synchronize` | rsync 常用参数组 |

### 函数（functions/，autoload）

| 函数 | 用途 |
|------|------|
| `extract <file>` | 万能解压（tar.gz/xz/zst/zip/7z/dmg…） |
| `tssh <host>` | tmux 内新窗口连远程（见 [git-and-remote.md](git-and-remote.md)） |
| `gi <模板…>` | 拉取 gitignore 模板，如 `gi macos node` |

## 导航

| 键/命令 | 效果 |
|---------|------|
| `z <目录名片段>` | 直跳高频目录（zoxide，取代 cd 的日常） |
| `ctrl+r` | fzf 搜历史（即时预览） |
| `ctrl+t` | fzf 把文件名插入当前命令 |
| `alt+c` | fzf 交互式 cd |
| `option+←/→` | 按词移动（ghostty `macos-option-as-alt`） |

## 补全行为

- 大小写不敏感 + **子串匹配** + 菜单式选择（连按 tab 循环）
- 粘贴含 tab 的文本不触发补全（`insert-tab pending`）
- 补全结果带缓存（`~/.cache/zsh-completions`）

## vim 模式（zsh-vim-mode）

`Esc` 进 NORMAL：`hjkl` 移动、`w/b` 跳词、`0/$` 行首尾、`v` 可视、
`ctrl+e`（NORMAL 下）编辑当前行。右提示符显示 INSERT/NORMAL 状态。
`KEYTIMEOUT=1` 保证 Esc 切换几乎无延迟。

## 环境与私有配置

- `EDITOR` / `VISUAL` = `nvim`（git、crontab 等全部跟随）
- **`~/.localrc`**：机器私有变量、别名（API key、代理等），zshrc 末尾加载，
  永不进仓库
- prompt 是 starship（两级提示 + git 状态 + 时长）
- 自动建议（灰色幽灵文本）：`→` 采纳整条，`ctrl+y` 采纳单词

## 排障速查

| 症状 | 处置 |
|------|------|
| 改了 zsh 配置没生效 | `reload!`；仍不行检查文件名（`*.zsh` / `path.zsh` / `completion.zsh` 约定） |
| 启动变慢 | `zmodload zsh/zprof` 放 zshrc 首行后 `zsh -i -c exit` 看 profile；清 `~/.cache/dotfiles` 重建缓存 |
| 补全丢失 | 确认 `~/.cache/dotfiles/completions/` 存在（重跑 `script/install herdr` 等） |
