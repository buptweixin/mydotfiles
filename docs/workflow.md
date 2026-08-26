# 工作流总纲

## 三层终端架构

```
┌─────────────────────────────────────────────────────┐
│ ghostty      渲染/窗口层：字体、主题、透明毛玻璃、       │
│              选区、quick terminal、原生 splits          │
│  ┌───────────────────────────────────────────────┐  │
│  │ tmux        会话层：分屏、多窗口、detach 存活、    │  │
│  │             OSC52 复制、SSH 远程会话              │  │
│  └───────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────┐  │
│  │ herdr       agent 会话层：常驻 server、状态标记   │  │
│  │             （与 tmux 平行，不嵌套）              │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

每层只做一件事，前缀键统一 `C-a`（tmux 与 herdr 各自独立生效，因为 herdr 不跑在 tmux 里）。

## 场景决策表

| 场景 | 用什么 | 入口 |
|------|--------|------|
| 日常 shell、本地开发、nvim | ghostty 标签 + tmux | 打开 ghostty 自动进 `tmx`；`cmd+t` 新标签 |
| 跑编码 agent（长任务、合盖走人） | ghostty 标签 + herdr | `cmd+t` 然后敲 `hr` |
| 临时看一眼 agent 状态 / 丢个命令 | quick terminal | `` cmd+` `` |
| 连远程服务器干活 | tmux 远程会话 | `ssht <host>`（tmux 里用 `tssh <host>`） |
| 本地轻量并行（看日志 + 写码） | ghostty 原生 splits | `cmd+d` / `cmd+shift+d` |
| 一次性小脚本、不需要会话存活 | 直接 ghostty（不经 tmux） | — |

**判断标准**：会话需不需要「离开终端后继续活」？不需要 → ghostty 直接跑；需要且是人用 → tmux；需要且是 agent 用 → herdr。

## 一天的典型工作流

1. **开机**：ghostty `window-save-state = always` 恢复窗口；首个标签自动 `tmx` attach 回 `main` 会话（昨天的一切都还在）。
2. **进入项目**：`z <项目名几个字母>` 直达目录（zoxide 按频率排序）；`v` 打开 nvim。
3. **起 agent**：`cmd+t` 新标签 → `hr` → 在项目目录的 herdr workspace 里让 claude code / codex 干活 → `prefix+d` detach，合盖走人。
4. **回来看进度**：quick terminal（`` cmd+` ``）→ `hr` → 侧栏看每个 agent 的 working / blocked / idle 状态；blocked 的去回答问题。
5. **代码审查**：回 tmux 标签 `gd` 看 diff（delta 渲染，`n`/`N` 跳 hunk）；`gl` 拉取（自动 `--prune`）。
6. **检索**：`rg` 找内容、`fd` 找文件、`ctrl+r` 翻历史（fzf）。
7. **收工**：直接关电脑。tmux 会话和 herdr server 都在后台，明天 `tmx` / `hr` 接着来。

## agent 工作流最佳实践

- **agent 永远放 herdr，不放 tmux pane**。三个理由：herdr 的 server 进程独立于终端生命周期（合盖/断网/重启不丢）；pane 状态标记（blocked = 等你回答）让多 agent 并行可巡检；agent 之间可以通过 socket API 互相 spawn pane。
- **人在的会话放 tmux**。你自己敲命令、看输出的地方用 tmx；herdr 只装 agent 工作区，边界清晰。
- **不要把 herdr 嵌进 tmux**（也不要反过来）。两边前缀都是 `C-a`，嵌套时外层会拦截按键。真要临时嵌套，先按外层的 F12 把外层键位关掉。
- **herdr 配合 quick terminal 做巡检**：`` cmd+` `` 唤出 → `hr` 看状态 → 失焦自动收起，不占 dock 位。
- **长输出用 prompt 跳转**：tmux/ghostty 里看 agent 日志，`cmd+shift+↑/↓`（ghostty 原生）在提示符间跳，比滚轮快。

## 剪贴板总论（三层复制路径）

| 场景 | 复制方式 | 到达位置 |
|------|---------|---------|
| ghostty 里选中文本 | 鼠标选择即复制（`copy-on-select = clipboard`） | 系统剪贴板 |
| tmux copy-mode | `prefix+[` → `v` 选 → `y` | OSC52 → 系统剪贴板 |
| SSH 远程 tmux（ssht） | 远程 copy-mode 里 `y` | OSC52 穿透 SSH → **本地**剪贴板 |

粘贴一律 `cmd+v`（ghostty 层）。跨机器复制不需要任何额外工具，这是 OSC52 + `set-clipboard external` + `allow-passthrough` 的组合效果，详见 [tmux.md](tmux.md)。
