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
set -g renumber-windows on
```

Windows and panes start at 1 instead of 0. Aligns with the keyboard —
`Prefix+1` reaches the first window without stretching to `0`.
`renumber-windows on` keeps window numbers contiguous when a window is
closed — without it, closing window 1 of three leaves windows 2 and 3,
breaking keyboard navigation.

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
