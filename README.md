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

**Nerd Font required for icons:** Neo-tree uses `nvim-web-devicons` which needs a
[Nerd Font](https://www.nerdfonts.com) installed and set as your terminal's font.
Without it, file icons in the explorer will render as broken boxes.

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

## Updating

### Config file changes (tmux, nvim, git, lazygit)

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

### When install.sh itself changes (new packages or symlinks)

If the repo adds new Homebrew/npm packages or new symlink entries, re-run
the script after pulling:

```bash
git pull
./install.sh
```

The script is safe to re-run on an existing machine. It checks what is
already in place and skips it — you will see `[SKIP]` for everything
already installed or linked, and `[OK]` only for what is genuinely new.
No uninstalling or starting from scratch is required.

**What the script does not do on re-run:**

- Upgrade packages that are already installed. Run `brew upgrade` or
  `npm update -g <pkg>` manually when you want to update a tool's version.
- Remove packages that were deleted from the script's lists. Uninstall
  those manually with `brew uninstall` / `npm uninstall -g`.

## Docs

- [Tmux config walkthrough](docs/tmux.md)
- [NeoVim config walkthrough](docs/nvim.md)
