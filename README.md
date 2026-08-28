# dotfiles

My personal configuration, organized topic-centric in the
[holman/dotfiles](https://github.com/holman/dotfiles) style: each directory is
a topic, `*.symlink` files get linked into `$HOME`, and `*.zsh` files get
sourced by zsh.

**Detailed guides live in [docs/](docs/index.md)** — per-tool manuals
(ghostty / tmux / herdr / zsh), the workflow playbooks that tie them
together, and a maintenance & troubleshooting handbook.

## install

Prerequisites:

- `bash`, `git`, `curl`
- macOS: Command Line Tools for Xcode via `xcode-select --install`

```sh
git clone https://github.com/buptweixin/mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

`script/bootstrap` symlinks every `*.symlink` into `$HOME` (interactive
backup/overwrite prompts for conflicts, idempotent for already-linked files),
optionally generates `git/gitconfig.local.symlink` from its `.example`
(your git identity lives there — the shared gitconfig carries none), then runs
`script/install`, which:

1. sets up Homebrew (installing it from the TUNA mirror if missing — set
   `DOTFILES_DISABLE_TUNA_HOMEBREW=1` to keep official sources), and
2. runs `brew bundle` with the `Brewfile` (`bat`, `gh`, `ncdu`, `node`, `npm`,
    `tmux`, `zoxide`, `zsh`), then
3. runs each topic's `install.sh` (ghostty, ssh, tmux, zsh, ...); the zsh
   installer installs plugins from `zsh/plugins.lock` at their pinned commits.

To re-run a single topic's installer: `script/install zsh` (or `script/install ssh tmux`).

Stash environment variables and machine-specific setup in `~/.localrc`; it is
sourced at the end of `zshrc` and stays out of this repo.

**Linux note:** the bootstrap is macOS-first. Homebrew on Linux works, but the
`ghostty` installer deliberately does not `brew install --cask` (casks are
macOS-only) — install Ghostty via your system package manager first. zsh, git,
and curl must be pre-installed (`apt install zsh git curl` or equivalent).

## where the tools come from

- **Brewfile/Homebrew** installs the CLI tools and other packages listed in
  the Brewfile. Homebrew is a rolling-release package manager, so the Brewfile
  is a package list, not a strict version lockfile.
- **`zsh/install.sh`** installs zsh plugins from `zsh/plugins.lock`, pinned to
  their complete commit SHAs.

The zsh startup files only load locally installed dependencies. Starting zsh
does not access the network or install anything.

Startup cost is kept low by caching `brew shellenv`, `starship init`, and
`zoxide init` output under `~/.cache/dotfiles/` (auto-regenerated after a
tool upgrade).

## components

- **bin/**: on `$PATH` via `system/path.zsh`.
- **topic/path.zsh**: loaded first; sets up `$PATH` and friends.
- **topic/\*.zsh**: loaded into the environment after path files.
- **topic/completion.zsh**: loaded last, after completions initialize.
- **topic/install.sh**: run by `script/install`.
- **topic/\*.symlink**: symlinked into `$HOME` by `script/bootstrap`.

Git identity is intentionally **not** in `git/gitconfig.symlink`; it lives in
`~/.gitconfig.local` (generated from `gitconfig.local.symlink.example`).

## tmux

1. split panes: `prefix + \` (vertical) or `prefix + -` (horizontal)
2. reload tmux config: `prefix + C-r`
3. create new window: `prefix + c`
4. rename window: `prefix + ,`, rename session: `prefix + $`
5. switch window: `prefix + C-[` previous, `prefix + C-]` next, `prefix + Tab` last
6. switch pane: `prefix + hjkl`; swap with next/previous: `prefix + C-o/O`
7. zoom pane: `prefix + z`
8. kill pane/window: `prefix + x/X`; kill other windows: `prefix + C-x`; kill session: `prefix + Q`
9. copy mode: `prefix + [` enter, `v` select, `y` copy, `prefix-p` paste, `prefix-b` list buffers, `prefix-P` choose buffer
10. refresh tmux environment from the active client: `prefix + E`

## ssh + tmux workflow

- `tmx` attaches or creates the local tmux session (detaching other clients
  first so a second terminal window takes over instead of mirroring).
  `tmx here` derives a session name from the current project directory.
- `ssht <host>` opens an SSH connection and attaches or creates a remote tmux
  session named after the host alias.
- `tssh <host>` does the same from inside tmux, but opens the remote session
  in a new local tmux window named after the host.
- `ssh/install.sh` manages a shared SSH include file under
  `~/.ssh/config.d/50-dotfiles.conf` and bootstraps `~/.ssh/config.local`
  with host alias examples.

## herdr (agent workspace runtime)

[herdr](https://github.com/herdrdev/herdr) is a persistent terminal runtime
for coding agents (claude code, codex, ...) — sessions live in a background
server and survive terminal close, lid close, and reboot. It complements
tmux rather than replacing it: ghostty's first surface launches into
herdr, human shells live in tmux (`tmx`), and herdr owns the agent
workspaces.

- `hr` runs herdr in the current directory — best in a dedicated ghostty
  tab (`cmd+t`, then `hr`).
- The prefix is `C-a`, same as tmux. Pane focus is vi-style
  (`prefix+hjkl`), zoom is `prefix+z`, close pane is `prefix+x`, and
  `prefix+d` detaches (rebound from herdr's default `prefix+q`).
- Running herdr *inside* a tmux pane would let the outer tmux swallow
  `C-a` — prefer standalone ghostty tabs, or rebind one of the two.
- Config is versioned at `herdr/config.toml` and linked to
  `~/.config/herdr/config.toml`; apply changes with
  `herdr server reload-config`. Its zsh completion is generated into
  `~/.cache/dotfiles/completions` at install time.
- `manage_ssh_config` stays on: herdr generates its own ssh config that
  includes `~/.ssh/config` first — it never edits our layered ssh setup.

## thanks

Forked years ago from [holman/dotfiles](https://github.com/holman/dotfiles)
(which itself credits [ryanb/dotfiles](https://github.com/ryanb/dotfiles));
the topic layout and bootstrap flow are still theirs. tmux snippets and the
OSC52 yank script draw from [gpakosz/.tmux](https://github.com/gpakosz/.tmux).
