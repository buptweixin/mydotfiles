# Ghostty 手册

配置文件：`ghostty/config.ghostty`（由 `ghostty/install.sh` 链接到
`~/Library/Application Support/com.mitchellh.ghostty/config`）。
保存即自动热重载；手动重载 `` cmd+q `` `r`。校验：`ghostty +validate-config`。

## 键位

### 本仓库自定义

| 键 | 动作 | 说明 |
|----|------|------|
| `` cmd+` `` | quick terminal | 顶部下拉终端，失焦自动收起；**仅在 ghostty 有焦点时可触发**，全局呼出需配 Raycast 等 |
| `ctrl+q` `c` | 新标签 | ctrl+q 是本配置的标签前缀 |
| `ctrl+q` `n` / `p` | 下/上一标签 | |
| `ctrl+q` `r` | 重载配置 | |

### 内置默认（好用但容易被忽略）

| 键 | 动作 | 场景 |
|----|------|------|
| `cmd+shift+p` | 命令面板 | 忘键位时按它，所有动作可搜索执行 |
| `cmd+shift+↑/↓` | 按提示符跳转 | 在长输出里逐条命令跳（依赖 shell integration） |
| `cmd+shift+j` | 回滚区 → 剪贴板（纯文本） | 抓完整输出 |
| `cmd+ctrl+shift+j` | 回滚区 → 文件 | agent 会话归档 |
| `cmd+opt+shift+j` | 回滚区 → 编辑器打开 | |
| `cmd+d` / `cmd+shift+d` | 右/下分屏 | 原生 splits，未聚焦 split 自动变暗 |
| `cmd+[` / `cmd+]` | 上/下一个 split | |
| `cmd+opt+方向键` | 按方向跳 split | |
| `cmd+shift+enter` | split 放大/还原 | |
| `cmd+1..9` | 跳标签（9 = 最后） | |
| `cmd+±0` | 字号增减/复位 | |

## 选区行为

双击选词由 `selection-word-chars` 控制（当前值）：

```
边界字符： 空格 TAB ' " │ ` | : ; , ( ) [ ] { } < > = # $ & * ~
词内字符： - . / @ _ ? + ^
```

即：`FOO=bar` 双击只选 `FOO`；`~/a/b/c`、`user@host`、`foo-bar` 整体选中。
已知的取舍：URL 的 query 在 `&` 处断开（`?a=1&b=2` 选不到 `b=2`）——
介意就把值里的 `&` 删掉。

- 选中即复制进系统剪贴板（`copy-on-select = clipboard`）
- 粘贴保护默认开启：粘贴含换行/控制字符的内容会弹确认，防命令注入
- `option+←/→` 按词跳转（`macos-option-as-alt = true`，接 zsh 的 `^[^[D` 绑定）

## 快速终端（quick terminal）

```
keybind = super+grave_accent=toggle_quick_terminal
quick-terminal-position = top
quick-terminal-animation-duration = 0.15
```

顶部滑入、失焦收起。典型用法：`` cmd+` `` → 敲 `hr` 看 agent 状态 → 鼠标点别处自动收起。
可调位置 `top|bottom|left|right|center`。

## 外观

- 主题 Catppuccin Mocha，字体 Maple Mono NF CN 15pt（`font-thicken` + `adjust-cell-height 2`）
- 85% 透明 + 30 半径毛玻璃 + 透明标题栏
- 浏览全部主题：`ghostty +list-themes`（实时预览）；浏览字体：`ghostty +list-fonts`
- Maple Mono 支持 OpenType 特性，如带斜杠的零：`font-feature = zero`

## 与 tmux / herdr 的分工

- 启动首个窗口默认进 herdr（`initial-command` 只作用于首个 surface）；后续新标签是普通 shell，`tmx` / `hr` 手动敲
- 原生 splits 适合「不需要会话存活的临时并行」；需要 detach 存活的用 tmux
- 真彩透传已配置（tmux 侧 `terminal-features ...,xterm-ghostty:RGB`）

## 常用命令行

```sh
ghostty +validate-config      # 校验配置
ghostty +show-config          # 查看生效配置（只列非默认项）
ghostty +show-config --default --docs  # 全量默认值 + 文档
ghostty +list-themes          # 主题浏览器
ghostty +list-fonts           # 字体浏览器
```
