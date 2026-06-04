# Workflow Cheatsheet

Quick reference for the full stack: Tmux → Neovim → Telescope → LSP → Git tools.

`<leader>` is **Space**. Tmux prefix is **Ctrl+a**.

---

## Tmux

### Sessions

| Command | Action |
|---------|--------|
| `dev` | Start or reattach to dev session |
| `dev my-name` | Named session |
| `Prefix + d` | Detach (session keeps running) |
| `tmux ls` | List running sessions |
| `tmux kill-session` | Kill current session |

### Windows (tabs)

| Key | Action |
|-----|--------|
| `Prefix + c` | New window |
| `Prefix + ,` | Rename window |
| `Prefix + 1–9` | Switch to window by number |
| `Prefix + n` | Next window |
| `Prefix + p` | Previous window |
| `Prefix + w` | Interactive window list |
| `Prefix + &` | Kill current window |

### Panes

| Key | Action |
|-----|--------|
| `Prefix + \|` | Split vertically (side by side) |
| `Prefix + -` | Split horizontally (top/bottom) |
| `Prefix + arrow` | Move between panes |
| `Prefix + z` | Zoom pane to full screen (toggle) |
| `Prefix + x` | Kill pane |
| `Prefix + {` / `}` | Swap pane left/right |
| `Prefix + q` | Show pane numbers |

### Misc

| Key | Action |
|-----|--------|
| `Prefix + g` | Open lazygit in a 50% side pane |
| `Prefix + r` | Reload tmux config |
| `Prefix + [` | Enter scroll/copy mode (use arrows or Vim keys) |
| `q` | Exit scroll mode |

---

## Neovim — Core

### Modes

| Key | Mode |
|-----|------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `o` / `O` | New line below / above and insert |
| `v` | Visual (character) |
| `V` | Visual (line) |
| `Ctrl+v` | Visual (block) |
| `Esc` | Back to Normal |
| `:` | Command mode |

### Navigation

| Key | Action |
|-----|--------|
| `h j k l` | Left / down / up / right |
| `w` / `b` | Next / previous word |
| `e` | End of word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Top / bottom of file |
| `Ctrl+d` / `Ctrl+u` | Half-page down / up |
| `Ctrl+f` / `Ctrl+b` | Full page down / up |
| `{` / `}` | Previous / next blank-line paragraph |
| `%` | Jump to matching bracket |
| `<C-o>` / `<C-i>` | Jump back / forward in jump list |

### Editing

| Key | Action |
|-----|--------|
| `dd` | Delete (cut) line |
| `yy` | Yank (copy) line |
| `p` / `P` | Paste after / before |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `ciw` | Change inner word |
| `diw` | Delete inner word |
| `ci"` | Change inside quotes |
| `di(` | Delete inside parentheses |
| `>>` / `<<` | Indent / unindent line |
| `=` (visual) | Auto-indent selection |
| `~` | Toggle case |
| `.` | Repeat last change |

### Search

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `*` / `#` | Search word under cursor forward / backward |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace with confirmation |

### Files & Buffers

| Key | Action |
|-----|--------|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:qa` | Quit all |
| `:e filename` | Open file |
| `:bd` | Close buffer |
| `Ctrl+^` | Toggle between last two buffers |

### Splits

| Key | Action |
|-----|--------|
| `:vsplit` / `:vs` | Vertical split |
| `:split` / `:sp` | Horizontal split |
| `Ctrl+h/j/k/l` | Navigate between splits |
| `:resize +5` | Grow horizontal split |
| `:vertical resize +5` | Grow vertical split |

---

## Neovim — Plugins

### Neo-tree (file explorer)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `a` (in tree) | New file / directory |
| `d` (in tree) | Delete |
| `r` (in tree) | Rename |
| `Enter` (in tree) | Open file |

### Telescope (fuzzy finder)

| Key | Action |
|-----|--------|
| `<leader>f` | Find files |
| `<leader>g` | Live grep (search file contents) |
| `<leader>b` | Open buffers |

**Inside any Telescope picker:**

| Key | Action |
|-----|--------|
| `Ctrl+j` / `Ctrl+k` | Move down / up |
| `Enter` | Open in current window |
| `Ctrl+x` | Open in horizontal split |
| `Ctrl+v` | Open in vertical split |
| `Ctrl+t` | Open in new tab |
| `Ctrl+u` | Clear the search prompt |
| `Esc` | Close picker |

### LSP (active in files with a language server)

Servers enabled: `pyright` (Python), `ts_ls` (TypeScript/JS), `lua_ls` (Lua).

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | All references (Telescope) |
| `<leader>ld` | Definitions (Telescope — useful when multiple exist) |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol across files |
| `<leader>ca` | Code actions (auto-imports, quick fixes) |
| `<C-o>` | Jump back after `gd` |

### Gitsigns (git-tracked files only)

| Key | Action |
|-----|--------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>hp` | Preview hunk popup |
| `<leader>hi` | Preview hunk inline |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hb` | Blame current line (full) |

### Diffview

| Key | Action |
|-----|--------|
| `<leader>dv` | Open Diffview (all changed files) |
| `<leader>dx` | Close Diffview |
| `:DiffviewOpen main..HEAD` | Diff against a branch |

---

## Lazygit

Open with `Prefix+g` in tmux or run `lazygit` in the terminal.

### Navigation

| Key | Action |
|-----|--------|
| `h/j/k/l` or arrows | Move between panels / items |
| `Tab` | Move to next panel |
| `[` / `]` | Previous / next tab |
| `?` | Show keybindings for current panel |

### Files & Staging

| Key | Action |
|-----|--------|
| `Space` | Stage / unstage file |
| `a` | Stage all / unstage all |
| `Enter` | Open file diff |
| `d` | Discard changes |
| `e` | Open file in editor |

### Commits

| Key | Action |
|-----|--------|
| `c` | Commit staged changes |
| `A` | Amend last commit |
| `r` | Rename last commit message |

### Branches & Remote

| Key | Action |
|-----|--------|
| `p` | Pull |
| `P` | Push |
| `n` (branches panel) | New branch |
| `Space` (branches panel) | Checkout branch |
| `M` | Merge selected branch into current |
| `R` | Rebase current branch onto selected |

### Stash

| Key | Action |
|-----|--------|
| `s` | Stash all changes |
| `Space` (stash panel) | Pop stash |
| `g` (stash panel) | Apply stash (keep it) |

---

## Plugin Management (lazy.nvim)

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager UI |
| `:Lazy update` | Update all plugins + rewrite lock file |
| `:Lazy install` | Install missing plugins |
| `:Lazy sync` | Install + update + clean |

Commit both `nvim/init.lua` and `nvim/lazy-lock.json` after updating to
propagate pinned versions to other machines.
