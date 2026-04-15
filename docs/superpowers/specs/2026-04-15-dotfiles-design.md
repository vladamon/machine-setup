# Dotfiles Repository Design

**Date:** 2026-04-15
**Topic:** Portable macOS terminal development environment (Tmux + NeoVim)
**Status:** Approved

---

## Overview

A single Git repository that captures the complete terminal development environment for macOS machines. Running one script from a fresh machine produces an identical environment — same Tmux bindings, same NeoVim plugins and keymaps, same plugin versions.

**Scope:** Tmux config, NeoVim config (lazy.nvim + plugins), and a Homebrew-based bootstrap script. No shell config (`.zshrc`) modifications. macOS only.

---

## Repository Structure

```
dotfiles/
├── install.sh                          # one-shot bootstrap script
├── README.md                           # overview + three-line quick-start
├── tmux/
│   └── .tmux.conf                      # symlinked → ~/.tmux.conf
├── nvim/
│   ├── init.lua                        # symlinked → ~/.config/nvim/init.lua
│   └── lazy-lock.json                  # pins plugin versions for reproducibility
└── docs/
    ├── tmux.md                         # walkthrough of every tmux setting
    └── nvim.md                         # walkthrough of every nvim setting + plugin
```

Config files live in the repo and are symlinked to their destinations. Edits made on any machine are immediately reflected in the repo (no copy step needed).

---

## Installation Script

`install.sh` executes these steps in order:

1. **Homebrew** — check if installed; if not, run the official install one-liner
2. **Packages** — `brew install tmux neovim ripgrep` (ripgrep is required by Telescope live grep)
3. **Backup** — if a target path already exists and is not already a symlink into this repo, rename it to `<target>.bak` before proceeding
4. **Symlink tmux** — `dotfiles/tmux/.tmux.conf` → `~/.tmux.conf`
5. **Symlink nvim** — `dotfiles/nvim/` → `~/.config/nvim`
6. **Status output** — each step prints `[OK]`, `[SKIP]` (already correct), or `[BACKED UP]`

The script touches nothing outside these two symlink targets. No `.zshrc` modifications, no PATH changes.

---

## Configuration Inventory

### Tmux (`~/.tmux.conf`)

| Setting | Value | Reason |
|---|---|---|
| Prefix | `Ctrl+a` | Ergonomic, avoids `Ctrl+b` conflict |
| Base index | 1 | Keyboard-order window switching |
| Mouse | on | Click to select pane/window |
| History limit | 10,000 | Generous scrollback |
| Escape time | 0ms | Instant escape key response in NeoVim |
| Splits | `\|` / `-` | Visual mnemonics for horizontal/vertical |
| Reload | `Prefix+r` | Quick config reload without restarting |

No plugins, no TPM, no custom status bar.

### NeoVim (`~/.config/nvim/`)

**Plugin manager:** `lazy.nvim` (not the LazyVim distribution)

| Plugin | Purpose |
|---|---|
| `navarasu/onedark.nvim` | Colorscheme (dark style) |
| `nvim-telescope/telescope.nvim` | Fuzzy finder (files, grep, buffers) |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting |
| `neovim/nvim-lspconfig` | LSP client configuration |
| `nvim-neo-tree/neo-tree.nvim` | File explorer sidebar |

**Key settings:** Space leader, relative + absolute line numbers, system clipboard, 2-space tabs, splits open right/below.

**Keymaps:**

| Key | Action |
|---|---|
| `<Space>f` | Telescope: find files |
| `<Space>g` | Telescope: live grep |
| `<Space>b` | Telescope: open buffers |
| `<Space>e` | Toggle Neo-tree |
| `Ctrl+h/j/k/l` | Navigate splits |

Plugin versions are pinned via `lazy-lock.json`.

---

## Documentation

| File | Contents |
|---|---|
| `README.md` | What this is, prerequisites, three-line quick-start, file map, update workflow |
| `docs/tmux.md` | Every `.tmux.conf` setting explained — what it does and why |
| `docs/nvim.md` | Every `init.lua` block explained — plugins, settings, keymaps |

Docs explain *this* config, not general tool tutorials.

---

## Constraints and Non-Goals

- **macOS only** — Homebrew is the sole package manager; no Linux support
- **No shell config** — `.zshrc` is not touched (too personal, too machine-specific)
- **No Zellij** — excluded deliberately; user is standardizing on Tmux
- **No auto-tmux launch** — the commented-out `.zshrc` block is intentionally omitted
- **No extra tooling** — no GNU Stow or other dotfile managers; install.sh is self-contained
