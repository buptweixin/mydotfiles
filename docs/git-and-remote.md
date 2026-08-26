# git 工具链与远程工作流

## 身份与凭据（分层设计）

```
~/.gitconfig          ← git/gitconfig.symlink（仓库管，无任何私人信息）
  └─ include ~/.gitconfig.local   ← git/gitconfig.local.symlink（本机生成，不入库）
       [user] name / email        ← 提交身份在这里改
       [credential] helper        ← macOS 默认 osxkeychain
```

- GitHub 推拉凭据走 **gh**：`credential.helper = !gh auth git-credential`。
  过期了跑 `gh auth login`；缺 scope（如 workflow）跑 `gh auth refresh -s <scope>`。
- 主配置的 `[user]` 是**故意留空**的——bootstrap 问卷从 `.example` 生成本地身份，
  公司/个人邮箱切换只改 `~/.gitconfig.local`。

## diff 与审查：delta

`core.pager = delta` + `interactive.diffFilter = delta --color-only`，
所有 `git diff / log / show` 自动进入 delta 渲染（语法高亮、行内变更、
并排布局由 delta 默认接管）。**`n` / `N` 在 hunk 间跳转**（`navigate = true`）。

## 别名三层体系

| 层 | 例子 | 用途 |
|----|------|------|
| shell alias（`git/aliases.zsh`） | `gl` `gp` `gd` `gco` | 高频、要和其他 shell 命令组合 |
| gitconfig alias | `git count`、`git co` | 供脚本/非交互环境用 |
| `bin/` 脚本 | `git-wtf` `git-up` | 逻辑复杂、需要参数处理 |

### bin/ 里的 git 脚本

| 脚本 | 用途 |
|------|------|
| `git-up` | pull 并显示变更 diffstat + 日志（比 `gl` 多一份"刚才发生了什么"） |
| `git-wtf` | 当前分支相对各 remote 的位置关系全景（Ruby 脚本） |
| `git-unpushed` / `git-unpushed-stat` | 未推送提交列表 / 统计 |
| `git-delete-local-merged` | 清理已合并进 HEAD 的本地分支（自动跳过 master/main） |
| `git-copy-branch-name` | 当前分支名进剪贴板 |
| `git-credit` / `git-rank-contributors` | 按行数/提交排名 |
| `git-amend` / `git-undo` | 便捷修正 / 撤销 |
| `git-nuke <branch>` | 删本地+远端分支（危险，先看清提示） |
| `git-promote` / `git-track` / `git-edit-new` | 合并到目标分支 / 设上游 / 编辑新文件 |

## ssh：分层配置

```
~/.ssh/config
  Include ~/.ssh/config.d/*.conf     ← 共享默认（ControlMaster 复用、KeepAlive…）
  Include ~/.ssh/config.local        ← 你的主机别名（占位模板 config.local.example）
  （herdr 的 remote 块若出现，在其后，优先级低于上面两层）
```

- 新机器：把主机别名写进 `~/.ssh/config.local`（不会进仓库）
- 连接复用已开启（ControlMaster），同一 host 第二个连接瞬间建立

## 远程工作流三件套

| 命令 | 场景 | 行为 |
|------|------|------|
| `ssht <host>` | 在 ghostty 直接连 | SSH + attach 远端以 host 命名的 tmux 会话 |
| `tssh <host>` | 已在本地 tmux 内 | 新开以 host 命名的 window 再走 ssht 流程 |
| （远程 tmux 里）`y` | 复制 | OSC52 穿透回**本地**剪贴板 |

会话名 sanitize 规则：大写转小写、非 `[a-z0-9._-]` 折叠为 `-`。

## 常用组合拳

```sh
gco -                       # 回上一分支
gl && git-up                # 拉取（带 prune）+ 看刚拉进来的东西
gd --staged                 # 看已暂存（delta 渲染）
git-delete-local-merged     # 合并完清分支
git-copy-branch-name        # 发 PR 前拿分支名
git wtf                     # 搞不清分支状态时
```
