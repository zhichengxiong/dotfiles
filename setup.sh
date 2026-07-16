#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="git@github.com:zhichengxiong/dotfiles.git"

echo "=== 1. Install stow ==="
if ! command -v stow &>/dev/null; then
  apt-get update && apt-get install -y stow
else
  echo "stow already installed"
fi

echo "=== 2. SSH key ==="
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "zhicheng.xiong@cohere.com" -f ~/.ssh/id_ed25519 -N ""
  echo "SSH key generated. Add this public key to GitHub → Settings → SSH keys:"
  echo ""
  cat ~/.ssh/id_ed25519.pub
  echo ""
  echo "Press Enter when done."
  read -r
else
  echo "SSH key already exists"
fi

echo "=== 3. Clone dotfiles ==="
if [ -d "$DOTFILES_DIR" ]; then
  echo "$DOTFILES_DIR already exists, skipping clone"
else
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

echo "=== 4. Stow configs ==="
stow -d "$DOTFILES_DIR" tmux opencode

echo "=== 5. Install opencode ==="
if ! command -v opencode &>/dev/null; then
  curl -fsSL https://opencode.ai/install | bash
else
  echo "opencode already installed"
fi

echo "=== 6. Add opencode to PATH ==="
if ! grep -q '.opencode/bin' ~/.bash_profile 2>/dev/null; then
  echo 'export PATH="$HOME/.opencode/bin:$PATH"' >> ~/.bash_profile
  echo "Added to ~/.bash_profile"
else
  echo "PATH already configured"
fi

echo ""
echo "Done! Run 'source ~/.bash_profile' or start a new shell."
