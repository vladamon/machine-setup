# Git Tools

## delta

A diff pager that adds syntax highlighting, line numbers, and word-level
diff highlighting to every `git diff`, `git log -p`, and `git show` output.

Config: `git/config` → symlinked as `~/.config/git/config`

Git reads both `~/.gitconfig` and `~/.config/git/config` as user-level
config, so these settings layer on top of any existing `~/.gitconfig`.

Key settings:

```ini
[delta]
    navigate = true      # n/N to jump between diff sections
    side-by-side = true  # two-column view (set false if terminal is narrow)
    line-numbers = true
    dark = true
```

`side-by-side = true` gives the clearest view of changes. If your terminal
is too narrow, set it to `false` in `git/config`.

---

## lazygit

A terminal UI for Git. Run it in a Tmux split alongside NeoVim:

```
Prefix+|   (open a side pane)
lazygit
```

Config: `lazygit/config.yml` → symlinked as `~/.config/lazygit/config.yml`

The config sets delta as lazygit's internal diff pager:

```yaml
git:
  paging:
    pager: "delta --dark --paging=never"
```

### Key bindings (lazygit defaults)

| Key | Action |
|-----|--------|
| `↑/↓` or `j/k` | Navigate lists |
| `enter` | Select / expand |
| `space` | Stage/unstage file or hunk |
| `c` | Commit staged changes |
| `p` | Push |
| `P` | Pull |
| `d` | Open diff for selected file/commit |
| `b` | Branch operations |
| `?` | Full keybinding reference |
| `q` | Quit lazygit |

### Workflow with NeoVim + Tmux

1. Open a Tmux split: `Prefix+|` (side) or `Prefix+-` (below)
2. Run `lazygit` in the new pane
3. Review changes with `d`, stage with `space`, commit with `c`
4. Switch back to NeoVim pane: `Ctrl+h/l` (or click with mouse)
