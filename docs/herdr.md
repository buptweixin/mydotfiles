# herdr 手册

[herdr](https://github.com/herdrdev/herdr) 是编码 agent 的常驻终端运行时。
配置文件：`herdr/config.toml`（由 `herdr/install.sh` 链接到
`~/.config/herdr/config.toml`）。

## 概念模型

- **server**：后台常驻进程，会话活在里面——合盖、断网、重启终端、重启机器后
  agent 继续工作。`herdr status` 查看状态。
- **session / workspace**：`herdr` 在当前目录起一个 workspace；
  也可 `herdr --session <name>` 用命名会话。
- **pane 状态标记**：每个 agent pane 显示 **working**（干活中）/
  **blocked**（卡住等你回答）/ **idle** / **done**。多 agent 并行的核心巡检手段。
- agent 可通过 CLI / socket API 驱动 herdr：互相 spawn pane、prompt、等待对方阻塞。

herdr **不包装不替代** claude code / codex 等工具，只拥有它们跑的终端。

## 入口与日常

| 操作 | 做法 |
|------|------|
| 在项目里起 agent 工作区 | 打开 ghostty 默认进 herdr；或 `cmd+t` 开新 ghostty 标签 → 敲 `hr`（= `exec herdr`） |
| 临时巡检 | quick terminal（`` cmd+` ``）→ `hr` → 看侧栏状态 → 失焦自动收起 |
| 离开 | `prefix+d` detach（对齐 tmux 肌肉记忆；原默认是 `prefix+q`） |
| 回来 | 任意终端再跑 `hr`（或 `herdr`） |

## 键位（本仓库配置下）

前缀 **`C-a`**（与 tmux 一致；因为 herdr 独立跑在 ghostty 标签里，不嵌套）。

| 键 | 动作 |
|----|------|
| `prefix+?` | 帮助 / 键位总览 |
| `prefix+s` | 设置界面 |
| `prefix+d` | detach |
| `prefix+h/j/k/l` | pane 焦点（vi 方向） |
| `prefix+z` | pane 放大 |
| `prefix+x` | 关 pane |
| `prefix+c` / `prefix+shift+t` | 新标签 / 改标签名 |
| `prefix+p` / `prefix+n` | 上 / 下一标签 |
| `prefix+1..9` | 跳标签 |
| `prefix+v` / `prefix+-` | 垂直 / 水平分屏 |
| `prefix+shift+n` / `shift+g` | 新 workspace / 新 git worktree |
| `prefix+w` / `prefix+g` | workspace 选择器 / goto |
| `prefix+e` | 编辑 pane 回滚内容 |
| `prefix+shift+r` | 重载配置 |
| `prefix+b` | 侧栏开关 |

## 配置管理

- 改 `herdr/config.toml` 后：`herdr server reload-config`（运行中即时生效），
  或 `prefix+shift+r`
- 恢复默认键位：`herdr config reset-keys`（自动备份）
- 本仓库的定制：`C-a` 前缀、`prefix+d` detach、tokyo-night 主题、关声音、
  系统通知、pane 边框显示 agent 标签、`/bin/zsh` 非 login pane
- 日志：`~/.config/herdr/herdr{,-server,-client}.log`（自动轮转）
- zsh 补全：`herdr/install.sh` 生成到 `~/.cache/dotfiles/completions/_herdr`

## 与 ssh / 远程

`herdr --remote <ssh-target>` 连远程 herdr server。
`manage_ssh_config = true` 时 herdr 生成**自己的** ssh 配置并优先 include
`~/.ssh/config`——不修改我们的分层 ssh 配置（`config.d/` + `config.local`），
主机别名照常解析。

## 最佳实践

1. **agent 放 herdr，人放 tmux**——见 [workflow.md](workflow.md) 的决策表。
2. **不要嵌套**：herdr 里再跑 tmux（或反之）会双层拦截 `C-a`；
   真需要时按外层的 F12 临时放行。
3. 多 agent 并行时用侧栏按状态巡检，优先处理 blocked；
   `[ui.sound]` 已关，靠系统通知（`[ui.toast] delivery = "system"`）提醒。
4. workspace 按项目分，`prefix+w` 快速切换；长任务 detach 后别盯屏。
