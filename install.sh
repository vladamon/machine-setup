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
