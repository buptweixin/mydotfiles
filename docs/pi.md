# pi (coding agent)

[pi](https://github.com/earendil-works/pi-coding-agent) is a terminal coding
agent. This topic versions its **extension set and per-extension configs** so a
new machine reaches the same pi setup with one `script/install pi`.

## What is versioned vs. not

`~/.pi/agent/` mixes shareable config with machine-local state and secrets.
Only the shareable, secret-free parts live in this repo:

| File in repo | Symlinked to | What it is |
|---|---|---|
| `pi/packages.txt` | — (not linked) | The extension source list; `install.sh` runs `pi install` for each |
| `pi/pi-lsp.json` | `~/.pi/agent/pi-lsp.json` | Language servers for `@narumitw/pi-lsp` |
| `pi/pi-fff.json` | `~/.pi/agent/pi-fff.json` | `@ff-labs/pi-fff` config (home-dir scanning off) |
| `pi/rtk-optimizer.json` | `~/.pi/agent/extensions/pi-rtk-optimizer/config.json` | `pi-rtk-optimizer` output-compaction settings |

**`settings.json` is deliberately not linked.** pi rewrites it at runtime
(`lastChangelogVersion`, the package array), so a symlink would let pi mutate
this repo. The package list is the source of truth instead: `packages.txt`
drives `pi install`, and pi owns the live `settings.json`.

These stay **machine-local and gitignored** (secrets or state):

- `auth.json`, `models.json`, `models-store.json`, `models.json.bak` — API keys
  and provider config, in plaintext
- `trust.json` — which directories pi is allowed to operate in
- `mcp-cache.json` — cached MCP tool metadata
- `settings.json` itself — see above

## What `install.sh` does

1. **pi itself** — if `command -v pi` is missing, `npm install -g
   @earendil-works/pi-coding-agent`. (pi is an npm global, not a brew cask;
   node/npm come from the Brewfile.)
2. **Extensions** — reads `packages.txt`, skips anything already in
   `settings.json`, runs `pi install` for the rest. Idempotent: re-running only
   installs new entries. Load order in `packages.txt` matters —
   `pi-extension-settings` must precede extensions that register settings
   (e.g. `pi-powerbar`).
3. **Configs** — symlinks the three read-only configs above into
   `~/.pi/agent/`, backing up any pre-existing real file to `*.bak.<timestamp>`.
4. **LSP dependencies** — `ty` and `ruff` via `uv tool install` (needs uv), and
   `bash-language-server` via `npm install -g`. `rtk` comes from the Brewfile
   instead.

## New-machine setup

```sh
git clone https://github.com/buptweixin/mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap        # symlinks + brew bundle + every topic's install.sh
# pi topic runs as part of the above; or re-run just it:
script/install pi
```

Then set the parts that are **not** versioned (do once per machine):

```sh
pi auth                 # add providers / API keys (writes auth.json, models.json)
# edit ~/.pi/agent/settings.json: defaultProvider, defaultModel, theme, thinkingLevel
# optional: pi install <extra extensions> and append to pi/packages.txt
```

## Notes & gotchas

- **pi-lsp from the home directory.** pi-lsp uses pi's cwd as the LSP workspace
  root. When pi is launched from `~` (the default for this dotfiles setup),
  `lsp_diagnostics` works if you pass an explicit `root`, but `lsp_fix` has no
  `root` parameter and will time out while the server scans the whole home dir.
  Start pi from inside a project directory when you need fixes; for ad-hoc
  fixes in a home-dir session, run `ruff check --fix` / `ruff format` directly.
  `pi-fff.json` disables home-dir indexing for the same reason.

- **pyright is intentionally not used.** pyright advertises neither pull
  diagnostics nor `openClose` in a way pi-lsp's client consumes, so diagnostics
  time out. `ty` (Astral's type checker, same vendor as ruff) declares the
  right capabilities and works out of the box.

- **`.zshrc` / `.bashrc` can't be linted by pi-lsp** — it matches files by
  `path.extname()`, which returns `""` for dotfiles. Rename to `foo.zsh` or
  rely on `shellcheck` directly for rc files.

- **Keeping `packages.txt` in sync.** After a manual `pi install`/`pi remove`,
  update `pi/packages.txt` so the next `script/install pi` reproduces the same
  set. Run `pi list` to audit.
