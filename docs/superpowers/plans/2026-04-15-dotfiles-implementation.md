# Dotfiles Repository Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a portable macOS terminal environment repo (Tmux + NeoVim) with a one-shot bootstrap script that replicates the full setup on any Mac.

**Architecture:** Configs live in the repo under `tmux/` and `nvim/` and are symlinked to their system destinations by `install.sh`. Homebrew handles all package installation. No external dotfile managers.

**Tech Stack:** Bash (install script), Lua (NeoVim config), Tmux config DSL, Homebrew, lazy.nvim (NeoVim plugin manager)

---

## File Map

| Path | Action | Responsibility |
|---|---|---|
| `.gitignore` | Create | Exclude OS noise |
| `install.sh` | Create | Bootstrap Homebrew, packages, symlinks |
| `README.md` | Create | Overview + quick-start |
| `tmux/.tmux.conf` | Create | Tmux configuration |
| `nvim/init.lua` | Create | NeoVim configuration |
| `nvim/lazy-lock.json` | Create | Pinned plugin versions |
| `docs/tmux.md` | Create | Tmux config walkthrough |
| `docs/nvim.md` | Create | NeoVim config walkthrough |

---

## Task 1: Repo skeleton and .gitignore

**Files:**
- Create: `.gitignore`
- Create: `tmux/` (directory)
- Create: `nvim/` (directory)
- Create: `docs/` (directory)

- [ ] **Step 1: Create directory structure**

```bash
mkdir -p tmux nvim docs
```

- [ ] **Step 2: Write .gitignore**

Create `.gitignore` with this exact content:

```gitignore
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Backups created by install.sh
*.bak
```

- [ ] **Step 3: Verify structure**

```bash
ls -la
```

Expected output includes: `tmux/`, `nvim/`, `docs/`, `.gitignore`

- [ ] **Step 4: Commit**

```bash
git add .gitignore tmux nvim docs
git commit -m "chore: initialize repo skeleton"
```

---

## Task 2: Tmux config

**Files:**
- Create: `tmux/.tmux.conf`

- [ ] **Step 1: Write tmux config**

Create `tmux/.tmux.conf` with this exact content:

```bash
# Basic tmux configuration

# Use Ctrl+a as the prefix instead of Ctrl+b
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Start window and pane numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Enable mouse support
set -g mouse on

# Increase scrollback history
set -g history-limit 10000

# Faster escape key handling (eliminates NeoVim Esc lag)
set -sg escape-time 0

# Split panes using | and -
bind | split-window -h
bind - split-window -v

# Reload config with Prefix + r
bind r source-file ~/.tmux.conf \; display-message "tmux config reloaded"
```

- [ ] **Step 2: Verify the file is syntactically valid**

```bash
tmux source-file tmux/.tmux.conf 2>&1
```

Expected: no output (silent success). If you see an error, check the line number reported and fix the typo.

- [ ] **Step 3: Commit**

```bash
git add tmux/.tmux.conf
git commit -m "feat: add tmux config"
```

---

## Task 3: NeoVim config

**Files:**
- Create: `nvim/init.lua`
- Create: `nvim/lazy-lock.json`

- [ ] **Step 1: Write init.lua**

Create `nvim/init.lua` with this exact content:

```lua
-- leader key
vim.g.mapleader = " "

-- basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- better splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "dark" })
      require("onedark").load()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({})
    end,
  },
})

-- telescope shortcuts
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})

-- neo-tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

-- better pane navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
```

- [ ] **Step 2: Write lazy-lock.json**

Create `nvim/lazy-lock.json` with this exact content (pins current plugin commits):

```json
{
  "lazy.nvim": { "branch": "main", "commit": "306a05526ada86a7b30af95c5cc81ffba93fef97" },
  "neo-tree.nvim": { "branch": "v3.x", "commit": "84c75e7a7e443586f60508d12fc50f90d9aee14e" },
  "nui.nvim": { "branch": "main", "commit": "de740991c12411b663994b2860f1a4fd0937c130" },
  "nvim-lspconfig": { "branch": "master", "commit": "d10ce09e42bb0ca8600fd610c3bb58676e61208d" },
  "nvim-treesitter": { "branch": "main", "commit": "4916d6592ede8c07973490d9322f187e07dfefac" },
  "nvim-web-devicons": { "branch": "master", "commit": "c72328a5494b4502947a022fe69c0c47e53b6aa6" },
  "onedark.nvim": { "branch": "master", "commit": "df4792accde9db0043121f32628bcf8e645d9aea" },
  "plenary.nvim": { "branch": "master", "commit": "74b06c6c75e4eeb3108ec01852001636d85a932b" },
  "telescope.nvim": { "branch": "master", "commit": "471eebb1037899fd942cc0f52c012f8773505da1" }
}
```

- [ ] **Step 3: Verify init.lua is parseable**

```bash
nvim --headless -u nvim/init.lua +qa 2>&1 | head -20
```

Expected: no Lua parse errors. Plugin installation errors are fine at this stage — they'll resolve once symlinked.

- [ ] **Step 4: Commit**

```bash
git add nvim/init.lua nvim/lazy-lock.json
git commit -m "feat: add neovim config"
```

---

## Task 4: install.sh

**Files:**
- Create: `install.sh`

- [ ] **Step 1: Write install.sh**

Create `install.sh` with this exact content:

```bash
#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()     { printf "${GREEN}[OK]${NC}        %s\n" "$1"; }
skip()   { printf "${YELLOW}[SKIP]${NC}      %s\n" "$1"; }
backed() { printf "${YELLOW}[BACKED UP]${NC} %s → %s.bak\n" "$1" "$1"; }

echo "── Dotfiles bootstrap ───────────────────────────────────"
echo ""

# ── Homebrew ─────────────────────────────────────────────────
echo "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ok "Homebrew installed"
else
  skip "Homebrew already present"
fi

# ── Packages ─────────────────────────────────────────────────
echo ""
echo "Checking packages..."
for pkg in tmux neovim ripgrep; do
  if brew list --formula "$pkg" &>/dev/null 2>&1; then
    skip "$pkg"
  else
    brew install "$pkg" --quiet
    ok "$pkg installed"
  fi
done

# ── Symlink helper ───────────────────────────────────────────
symlink() {
  local src="$1"
  local dst="$2"

  # Already pointing to the right place
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    skip "$dst already symlinked"
    return
  fi

  # Exists but is not our symlink — back it up
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "${dst}.bak"
    backed "$dst"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  ok "Linked: $(basename "$src") → $dst"
}

# ── Tmux ─────────────────────────────────────────────────────
echo ""
echo "Linking tmux config..."
symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# ── NeoVim ───────────────────────────────────────────────────
echo ""
echo "Linking NeoVim config..."
symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo ""
echo "────────────────────────────────────────────────────────"
echo "Bootstrap complete."
echo ""
echo "Next steps:"
echo "  1. Start a new tmux session:  tmux new -s main"
echo "  2. Open NeoVim:               nvim"
echo "     Plugins install automatically on first launch."
```

- [ ] **Step 2: Make executable**

```bash
chmod +x install.sh
```

- [ ] **Step 3: Verify the script runs correctly on this machine**

The machine already has everything installed, so every step should print `[SKIP]` or `[OK]` (symlinks will be created/backed up):

```bash
./install.sh
```

Expected output (exact order):
```
── Dotfiles bootstrap ───────────────────────────────────

Checking Homebrew...
[SKIP]      Homebrew already present

Checking packages...
[SKIP]      tmux
[SKIP]      neovim
[SKIP]      ripgrep

Linking tmux config...
[OK]        Linked: .tmux.conf → /Users/<you>/.tmux.conf
  (or [SKIP] if symlink already correct)

Linking NeoVim config...
[OK]        Linked: nvim → /Users/<you>/.config/nvim
  (or [SKIP] if symlink already correct)

────────────────────────────────────────────────────────
Bootstrap complete.
```

If `~/.tmux.conf` or `~/.config/nvim` existed and was not already our symlink, it will have been renamed to `.bak`.

- [ ] **Step 4: Verify symlinks point correctly**

```bash
ls -la ~/.tmux.conf
ls -la ~/.config/nvim
```

Expected:
```
~/.tmux.conf -> /Users/<you>/Documents/code/dotfiles/tmux/.tmux.conf
~/.config/nvim -> /Users/<you>/Documents/code/dotfiles/nvim
```

- [ ] **Step 5: Commit**

```bash
git add install.sh
git commit -m "feat: add bootstrap install script"
```

---

## Task 5: README.md

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write README.md**

Create `README.md` with this exact content:

```markdown
# dotfiles

Portable macOS terminal development environment — Tmux + NeoVim.

## Quick start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

That's it. The script installs Homebrew (if missing), installs `tmux`, `neovim`,
and `ripgrep`, then symlinks the configs to their correct locations.

## What gets installed

| Tool | Config location | Source in this repo |
|------|----------------|---------------------|
| Tmux 3.6+ | `~/.tmux.conf` | `tmux/.tmux.conf` |
| NeoVim 0.12+ | `~/.config/nvim/` | `nvim/` |

**System dependencies installed via Homebrew:** `tmux`, `neovim`, `ripgrep`

## First launch

**Tmux:**
```bash
tmux new -s main
```

**NeoVim:**
```bash
nvim
```
Plugins install automatically on first launch via lazy.nvim. Wait for the
progress window to complete, then restart NeoVim.

## Updating configs

Configs are symlinked from this repo, so edits on the machine are already
in the repo. To sync changes across machines:

```bash
# On the machine where you made changes
cd ~/.dotfiles
git add -p
git commit -m "update: ..."
git push

# On another machine
cd ~/.dotfiles
git pull
# Changes take effect immediately — no re-running install.sh needed.
```

To update NeoVim plugins: open NeoVim, run `:Lazy update`, then commit the
updated `nvim/lazy-lock.json`.

## Docs

- [Tmux config walkthrough](docs/tmux.md)
- [NeoVim config walkthrough](docs/nvim.md)
```

- [ ] **Step 2: Update the clone URL**

Replace `YOUR_USERNAME` in `README.md` with your actual GitHub username:

```
https://github.com/vladimircutkovic/dotfiles.git
```

(Or whatever username you use — check `gh api user --jq .login` to confirm.)

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add README with quick-start"
```

---

## Task 6: docs/tmux.md

**Files:**
- Create: `docs/tmux.md`

- [ ] **Step 1: Write docs/tmux.md**

Create `docs/tmux.md` with this exact content:

```markdown
# Tmux Configuration

Config file: `tmux/.tmux.conf` → symlinked to `~/.tmux.conf`

---

## Prefix key

```
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

Default tmux prefix is `Ctrl+b`. Remapped to `Ctrl+a` — more ergonomic and
mirrors the classic GNU Screen convention. `bind C-a send-prefix` lets you
pass `Ctrl+a` through to the shell (e.g., jump to line start in zsh) by
pressing the prefix twice.

## Window and pane numbering

```
set -g base-index 1
setw -g pane-base-index 1
```

Windows and panes start at 1 instead of 0. Aligns with the keyboard —
`Prefix+1` reaches the first window without stretching to `0`.

## Mouse support

```
set -g mouse on
```

Click to focus panes, drag to resize them, scroll with the trackpad.
Does not interfere with keyboard-driven workflows.

## Scrollback history

```
set -g history-limit 10000
```

Stores 10,000 lines per pane (default is 2,000). Useful when tailing logs
or running long test suites.

## Escape time

```
set -sg escape-time 0
```

By default tmux waits 500ms after `Esc` to check for escape sequences.
This causes visible lag in NeoVim when leaving insert mode. Setting it to
0 eliminates the delay entirely.

## Split panes

```
bind | split-window -h
bind - split-window -v
```

`Prefix+|` splits horizontally (side by side).
`Prefix+-` splits vertically (top and bottom).
The characters visually represent the resulting divider.

## Reload config

```
bind r source-file ~/.tmux.conf \; display-message "tmux config reloaded"
```

`Prefix+r` reloads the config without restarting tmux. The status bar
message confirms the reload completed.

---

## Key reference

| Key | Action |
|-----|--------|
| `Ctrl+a` | Prefix |
| `Prefix + \|` | Split pane horizontally |
| `Prefix + -` | Split pane vertically |
| `Prefix + r` | Reload config |
| `Prefix + [` | Enter scroll/copy mode (use arrow keys or vi keys) |
| `Prefix + d` | Detach from session |
| `Prefix + c` | New window |
| `Prefix + 1-9` | Switch to window N |
| `Prefix + ,` | Rename current window |
| `Prefix + $` | Rename current session |
```

- [ ] **Step 2: Commit**

```bash
git add docs/tmux.md
git commit -m "docs: add tmux config walkthrough"
```

---

## Task 7: docs/nvim.md

**Files:**
- Create: `docs/nvim.md`

- [ ] **Step 1: Write docs/nvim.md**

Create `docs/nvim.md` with this exact content:

```markdown
# NeoVim Configuration

Config: `nvim/init.lua` → symlinked to `~/.config/nvim/init.lua`
Lock file: `nvim/lazy-lock.json` → pins exact plugin versions

---

## Plugin manager

`lazy.nvim` is the plugin manager (not to be confused with the LazyVim
*distribution*, which is a full config framework built on lazy.nvim).
Here, lazy.nvim is just the loader — all configuration lives in `init.lua`.

On first launch, lazy.nvim installs itself and all listed plugins
automatically. A progress window appears; wait for it to complete, then
restart NeoVim.

---

## Core settings

```lua
vim.g.mapleader = " "          -- Space as leader key
vim.opt.number = true          -- Absolute line number on current line
vim.opt.relativenumber = true  -- Relative numbers on all other lines
vim.opt.mouse = "a"            -- Mouse in all modes
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.termguicolors = true   -- 24-bit color

vim.opt.tabstop = 2            -- Tab displays as 2 spaces
vim.opt.shiftwidth = 2         -- >> / << indent by 2 spaces
vim.opt.expandtab = true       -- Insert spaces, not tab characters

vim.opt.splitright = true      -- :vsplit opens to the right
vim.opt.splitbelow = true      -- :split opens below
```

---

## Plugins

### navarasu/onedark.nvim

Colorscheme. `priority = 1000` ensures it loads before other plugins so
colors are in place from the start. Uses the `dark` style variant.

### nvim-telescope/telescope.nvim

Fuzzy finder for files, text search, and buffer switching. Backed by
`plenary.nvim` (utility library). `<Esc>` closes the picker in insert mode
(the default binding is `<C-c>`).

Live grep (`<Space>g`) requires `ripgrep` installed on the system
(`brew install ripgrep`).

### nvim-treesitter/nvim-treesitter

Accurate syntax highlighting via language-specific parsers. `:TSUpdate`
runs on install/update to fetch the latest parsers. Parsers are downloaded
per-language on demand.

### neovim/nvim-lspconfig

Official LSP client configuration helper. Provides the framework to connect
NeoVim to language servers. Language servers are installed separately.

To add a language server, append to `init.lua`:
```lua
require("lspconfig").pyright.setup({})   -- Python
require("lspconfig").ts_ls.setup({})     -- TypeScript/JavaScript
```

Then install the server: `brew install pyright` or via `npm install -g typescript-language-server`.

### nvim-neo-tree/neo-tree.nvim

File explorer sidebar. `lazy = false` loads it eagerly (not deferred on
first use). Icons require a Nerd Font installed and set in your terminal
emulator preferences.

---

## Keymaps

### Telescope (fuzzy finder)

| Key | Action |
|-----|--------|
| `<Space>f` | Find files |
| `<Space>g` | Live grep (search file contents) |
| `<Space>b` | Open buffers |

### Neo-tree (file explorer)

| Key | Action |
|-----|--------|
| `<Space>e` | Toggle file explorer |

### Split navigation

| Key | Action |
|-----|--------|
| `Ctrl+h` | Move to left split |
| `Ctrl+l` | Move to right split |
| `Ctrl+j` | Move to split below |
| `Ctrl+k` | Move to split above |

---

## Plugin management

**Add a plugin:** Add an entry to the `require("lazy").setup({})` table in
`init.lua`:

```lua
{
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({})
  end,
},
```

Run `:Lazy sync` inside NeoVim to install. Commit both `init.lua` and the
updated `nvim/lazy-lock.json`.

**Update all plugins:** Inside NeoVim: `:Lazy update`

Updates plugins to their latest versions and rewrites `nvim/lazy-lock.json`.
Commit the lock file to propagate pinned versions to other machines.
```

- [ ] **Step 2: Commit**

```bash
git add docs/nvim.md
git commit -m "docs: add neovim config walkthrough"
```

---

## Task 8: Final verification

- [ ] **Step 1: Check repo structure matches the design**

```bash
find . -not -path './.git/*' -not -path './docs/superpowers/*' | sort
```

Expected output:
```
.
./.gitignore
./README.md
./docs
./docs/nvim.md
./docs/tmux.md
./install.sh
./nvim
./nvim/init.lua
./nvim/lazy-lock.json
./tmux
./tmux/.tmux.conf
```

- [ ] **Step 2: Verify symlinks are live and correct**

```bash
readlink ~/.tmux.conf
readlink ~/.config/nvim
```

Both should resolve to absolute paths inside this repo.

- [ ] **Step 3: Verify NeoVim loads without errors**

```bash
nvim --headless +checkhealth +qa 2>&1 | grep -E "ERROR|WARNING" | head -20
```

Any errors about missing language servers are expected and fine — those are
optional. Errors about missing plugins indicate the symlink or lazy-lock is
broken.

- [ ] **Step 4: Check git log looks clean**

```bash
git log --oneline
```

Expected (newest first):
```
<hash> docs: add neovim config walkthrough
<hash> docs: add tmux config walkthrough
<hash> docs: add README with quick-start
<hash> feat: add bootstrap install script
<hash> feat: add neovim config
<hash> feat: add tmux config
<hash> chore: initialize repo skeleton
<hash> Add dotfiles repo design spec
```

- [ ] **Step 5: Done — push to GitHub**

```bash
gh repo create dotfiles --public --source=. --remote=origin --push
```

Or if the repo already exists on GitHub:
```bash
git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git
git push -u origin main
```
