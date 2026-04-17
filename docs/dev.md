# Dev Launcher

Script: `bin/dev` → symlinked as `~/bin/dev` and `~/bin/vlad-dev`

Spins up (or reattaches to) a tmux session named `dev` with four windows
pre-configured for a terminal-native workflow.

```
dev              # start or reattach
dev my-session   # use a custom session name
```

---

## Window layout

### 1. main

```
┌──────────┬──────────┐
│  nvim .  │ lazygit  │
├──────────│          │
│  shell   │          │
└──────────┴──────────┘
```

Open a file immediately, review git state on the right, run agents or tests
in the bottom-left shell.

### 2. servers

```
┌──────────┬──────────┐
│ server-a │ server-b │
│          │          │
└──────────┴──────────┘
```

Two side-by-side panes for running services simultaneously.

### 3. ops

```
┌──────────────────────┐
│      commands        │
├──────────────────────┤
│   output/monitoring  │
└──────────────────────┘
```

Top pane for commands (kubectl, docker-compose, etc.), bottom for log
output or monitoring.

### 4. misc

Single pane. General-purpose scratch shell.

---

## Switching windows

| Key | Action |
|-----|--------|
| `Prefix + 1` | main |
| `Prefix + 2` | servers |
| `Prefix + 3` | ops |
| `Prefix + 4` | misc |

---

## PATH requirement

`~/bin` must be in your PATH. Add to `~/.zshrc` if not already present:

```sh
export PATH="$HOME/bin:$PATH"
```
