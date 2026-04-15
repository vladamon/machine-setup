# dotfiles

Portable macOS terminal development environment — Tmux + NeoVim.

## Quick start

```bash
git clone https://github.com/vladamon/dotfiles.git ~/.dotfiles
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
