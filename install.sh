#!/usr/bin/env bash
set -euo pipefail

SCRIPT="$(realpath "${BASH_SOURCE[0]}" 2>/dev/null || readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || "${BASH_SOURCE[0]}")"
DOTFILES_DIR="$(cd "$(dirname "$SCRIPT")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()     { printf "${GREEN}[OK]${NC}        %s\n" "$1"; }
skip()   { printf "${YELLOW}[SKIP]${NC}      %s\n" "$1"; }
backed() { printf "${YELLOW}[BACKED UP]${NC} %s → %s\n" "$1" "$2"; }

echo "── Dotfiles bootstrap ───────────────────────────────────"
echo ""

# ── Homebrew ─────────────────────────────────────────────────
echo "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Bring brew into PATH for the remainder of this script
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  ok "Homebrew installed"
else
  skip "Homebrew already present"
fi

# ── Packages ─────────────────────────────────────────────────
echo ""
echo "Checking packages..."
for pkg in tmux neovim ripgrep lazygit git-delta; do
  if brew list --formula "$pkg" &>/dev/null 2>&1; then
    skip "$pkg"
  else
    brew install "$pkg" --quiet
    ok "$pkg installed"
  fi
done

# ── Node / tree-sitter CLI ───────────────────────────────────
echo ""
echo "Checking Node.js tooling..."
if ! command -v npm &>/dev/null; then
  echo "  npm not found — install Node.js (e.g. via nvm) then re-run."
else
  if npm list -g tree-sitter-cli --depth=0 &>/dev/null 2>&1; then
    skip "tree-sitter-cli"
  else
    npm install -g tree-sitter-cli --silent
    ok "tree-sitter-cli installed"
  fi
fi

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
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    backed "$dst" "$backup"
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

# ── Git (delta pager) ────────────────────────────────────────
echo ""
echo "Linking Git config..."
symlink "$DOTFILES_DIR/git/config" "$HOME/.config/git/config"

# ── Lazygit ──────────────────────────────────────────────────
echo ""
echo "Linking Lazygit config..."
symlink "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

# ── Dev launcher ─────────────────────────────────────────────
echo ""
echo "Linking dev launcher..."
symlink "$DOTFILES_DIR/bin/dev" "$HOME/bin/dev"
symlink "$DOTFILES_DIR/bin/dev" "$HOME/bin/vlad-dev"

echo ""
echo "────────────────────────────────────────────────────────"
echo "Bootstrap complete."
echo ""
echo "Next steps:"
echo "  1. Ensure ~/bin is in your PATH. Add to ~/.zshrc if needed:"
echo "       export PATH=\"\$HOME/bin:\$PATH\""
echo "  2. Start your dev environment:  dev"
echo "     (re-run anytime to reattach — session persists)"
echo "  3. On first NeoVim launch, plugins install automatically."
