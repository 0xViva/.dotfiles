#!/bin/zsh

echo "Running .zshrc..."
echo "Login using ssh:"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
# Detect OS
if [[ "$(uname -s)" == "Darwin" ]]; then
  OS_TYPE="macos"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  OS_TYPE="wsl"
elif [[ -f /etc/arch-release ]]; then
  OS_TYPE="arch"
else
  OS_TYPE="unknown"
fi

echo "Detected OS_TYPE: $OS_TYPE"

case "$OS_TYPE" in
  "macos")
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
esac

if [[ -x "$HOME/.dotfiles/OS/${OS_TYPE}" ]]; then
    source "$HOME/.dotfiles/OS/${OS_TYPE}"
    STOW_FOLDERS=$STOW_FOLDERS
fi
export PATH=$PATH:.local/bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.foundry/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export DOTFILES="$HOME/.dotfiles"
export GIT_CONFIG_GLOBAL="$HOME/.dotfiles/git/.gitconfig"
export GPG_TTY=$(tty)
export GOPATH="$HOME/go"

# oh-my-posh prompt
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"
fi

# fzf integration
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# yazi wrapper
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

if command -v hyprctl >/dev/null 2>&1; then
  echo "Reloading Hyprland..."
  hyprctl reload || true
fi

# Bun shell completions
if [[ -s "$HOME/.bun/_bun" ]]; then
  source "$HOME/.bun/_bun"
fi

