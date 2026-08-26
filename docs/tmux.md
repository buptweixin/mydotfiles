# tmux 手册

配置文件：`tmux/tmux.conf.symlink` → `~/.tmux.conf`。重载 `prefix+C-r`，
编辑并重载 `prefix+C-e`。辅助脚本由 `tmux/install.sh` 复制到 `~/.tmux/`。

## 入口

| 命令 | 行为 |
|------|------|
| `tmx` | 在当前目录 attach 或创建 `main` 会话；已有其他终端连着时**接管**（detach 旧端，`-D`），不镜像 |
| `tmx here` | 按当前 git 仓库名（或目录名）派生会话名 |
| `ssht <host>` | SSH 连接并 attach 远端同名 tmux 会话（见 [git-and-remote.md](git-and-remote.md)） |
| `tssh <host>` | 同上，但在 tmux 内新开一个以 host 命名的 window |

ghostty 的 `initial-command` 直接跑 `tmx`，所以每个标签天然在 tmux 里。

## 前缀与通用

前缀 **`C-a`**（unbind 了默认 C-b）。`mouse off` 是有意为之：
选择交给 ghostty 的选区，操作全键盘化。

| 键 | 动作 |
|----|------|
| `prefix+c` | 新窗口（继承当前路径） |
| `prefix+,` / `prefix+$` | 改窗口 / 会话名 |
| `prefix+C-[` / `C-]` | 上 / 下一窗口 |
| `prefix+Tab` | 最近使用的窗口（MRU） |
| `prefix+x` / `X` | 关 pane / 窗口 |
| `prefix+C-x` | 关其他所有窗口 |
| `prefix+Q` | 关整个会话 |
| `prefix+d` / `D` | detach / detach 其他客户端 |
| `prefix+C-s` | 隐藏/显示状态栏 |
| `prefix+C-e` | 编辑 tmux.conf（存盘自动重载） |
| `prefix+C-r` | 重载配置 |
| `prefix+m` / `M` | 窗口活动 / 静默监控 |
| `prefix+C-l` | 从其他会话 link 窗口 |
| `prefix+C-u` | 合并会话 |

## 分屏（pane）

| 键 | 动作 |
|----|------|
| `prefix+\` | 垂直分屏（继承路径） |
| `prefix+-` | 水平分屏（继承路径） |
| `prefix+h/j/k/l` | 焦点移动（vi 方向，可 repeat） |
| `prefix+H/J/K/L` | 调整大小（步进 2，可 repeat） |
| `prefix+o` / `O` | 与下/上一个 pane 交换 |
| `prefix+z` | pane 全屏切换 |
| `prefix+q`（tmux 默认） | 显示 pane 编号 |

## 复制模式（vi）与剪贴板链路

`prefix+[` 或 `prefix+Enter` 进入 copy-mode：

| 键 | 动作 |
|----|------|
| `v` / `C-v` | 开始选择 / 矩形选择 |
| `y` / `Enter` | 复制并退出 |
| `Esc` | 退出 |
| `H` / `L` | 行首 / 行尾 |
| `C-u/C-d` | 翻页；`C-y/C-e` 半页；`C-k/C-j` 单行 |

复制后经 `~/.tmux/yank.sh` 走 **OSC52**：

- 本地：ghostty `set-clipboard external` 接住 → 系统剪贴板
- SSH 远程（`ssht`）：OSC52 序列穿透 SSH 到本地终端 → **复制回本地剪贴板**，
  这是「远程 tmux 里 y、本地 cmd+v」的完整链路（依赖 `allow-passthrough on`）
- 粘贴：`prefix+p`（tmux buffer）或 `cmd+v`（系统剪贴板）；
  `prefix+b` 列 buffer，`prefix+P` 挑选粘贴

## 嵌套会话（本地 tmux → 远程 tmux）

两层 tmux 前缀都是 C-a 会打架。按 **`F12`** 把**外层（本地）**键位全部关掉
（状态栏会变成警示配色），所有键直透内层/远程；再按 `F12` 恢复。
`ssht` 场景不存在这个问题（远端会话直接占满本地窗口，只有一层本地键位）。

## 环境变量刷新

SSH 进来、挂上 VPN、或 `direnv` 变更后，tmux 里旧环境不会自动更新。
按 **`prefix+E`** 运行 `~/.tmux/renew_env.sh`，把当前 shell 的关键环境变量
更新进 tmux 会话（配合 `update-environment` 列表）。

## 状态栏

右侧每 5s 刷新：在线状态 ●、CPU/MEM（sysstat）、电池。prefix 高亮块会显示
当前是否在 copy-mode。插件由 TPM 管理（battery / prefix-highlight /
online-status / sidebar / copycat / open / sysstat），装新插件后 `prefix+I`。

## 设计要点（为什么这么配）

- `default-command "exec /bin/zsh -i"`（非 login）：绕开 macOS `/etc/zprofile`
  的 path_helper 打碎含空格 PATH 的问题——herdr 配置同此理由
- `escape-time 10`：兼顾 vim Esc 响应与老应用兼容
- `focus-events on`：tmux 内 nvim 的 autoread 能感知焦点
- `allow-passthrough on`：OSC52 与终端转义穿透的开关
