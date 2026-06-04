# NeoVim Configuration

Config: `nvim/` directory → symlinked as `~/.config/nvim/`
Lock file: `nvim/lazy-lock.json` → accessible via the directory symlink

---

## Plugin manager

`lazy.nvim` is the plugin manager (not to be confused with the LazyVim
*distribution*, which is a full config framework built on lazy.nvim).
Here, lazy.nvim is just the loader — all configuration lives in `init.lua`.

On first launch, lazy.nvim bootstraps itself (cloning from GitHub if not
already present) and installs all listed plugins automatically. A progress
window appears; wait for it to complete, then restart NeoVim.

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
`plenary.nvim` (utility library). `<Esc>` closes the picker in insert mode.

Live grep (`<Space>g`) requires `ripgrep` installed on the system
(installed by `install.sh`).

### nvim-treesitter/nvim-treesitter

Accurate syntax highlighting via language-specific parsers. On install,
parsers for lua, python, javascript, typescript, bash, json, and yaml are
auto-installed. `:TSUpdate` runs on update to fetch the latest parsers.

### neovim/nvim-lspconfig

LSP client configuration. Ships server definitions (cmd, filetypes, root
detection) for hundreds of language servers. In Neovim 0.11+, these
definitions are picked up automatically — you enable servers with
`vim.lsp.enable()` rather than calling `setup()` on each one.

Servers currently enabled: `pyright` (Python), `ts_ls` (TypeScript/JS),
`lua_ls` (Lua). Binaries are installed by `install.sh`.

To add a language server:
1. Install the binary (Homebrew or npm)
2. Add the name to `vim.lsp.enable({...})` in `init.lua`
3. If you need non-default settings, add a `vim.lsp.config("name", {...})` call before `vim.lsp.enable`

LSP keymaps are buffer-local and only activate when a server attaches
(via the `LspAttach` autocommand). They never pollute buffers without LSP.

### nvim-neo-tree/neo-tree.nvim

File explorer sidebar. `lazy = false` loads it eagerly (not deferred on
first use). Icons require a Nerd Font installed and set in your terminal
emulator preferences.

### lewis6991/gitsigns.nvim

Real-time Git gutter signs (added/changed/deleted lines) based on the
working tree. Updates automatically when external tools (AI agents, scripts)
modify files — no manual refresh needed. Keymaps are buffer-local via
`on_attach`, so they only activate in Git-tracked files and don't pollute
the global keymap space. `current_line_blame` is off by default — use
`<Space>hb` for blame on demand.

### sindrets/diffview.nvim

Full-screen tabpage showing all changed files with side-by-side diffs.
Loaded on demand (`cmd = { ... }`) so it doesn't affect startup time.
Open with `<Space>dv` to review every change the AI agent made in one view;
close with `<Space>dx`. Can also diff between commits or branches:
`:DiffviewOpen main..HEAD`.

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

### Gitsigns (hunk actions — buffer-local, git files only)

| Key | Action |
|-----|--------|
| `]h` | Jump to next hunk |
| `[h` | Jump to previous hunk |
| `<Space>hp` | Preview hunk in popup |
| `<Space>hi` | Preview hunk inline |
| `<Space>hs` | Stage hunk |
| `<Space>hr` | Reset hunk |
| `<Space>hb` | Full blame for current line |

### LSP (buffer-local — only in files with a language server)

| Key | Action |
|-----|--------|
| `gd` | Jump to definition |
| `gD` | Jump to declaration |
| `gr` | All references (Telescope picker) |
| `<Space>ld` | Definitions (Telescope picker — useful with multiple results) |
| `K` | Hover documentation popup |
| `<Space>rn` | Rename symbol across files |
| `<Space>ca` | Code actions (auto-imports, quick fixes) |
| `<C-o>` | Jump back after `gd` (built-in Neovim jump list) |

### Diffview (full-screen diff)

| Key | Action |
|-----|--------|
| `<Space>dv` | Open Diffview (all changed files) |
| `<Space>dx` | Close Diffview |

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

Run `:Lazy install` inside NeoVim to install. Commit both `init.lua` and the
updated `nvim/lazy-lock.json`.

**Update all plugins:** Inside NeoVim: `:Lazy update`

Updates plugins to their latest versions and rewrites `nvim/lazy-lock.json`.
Commit the lock file to propagate pinned versions to other machines.
