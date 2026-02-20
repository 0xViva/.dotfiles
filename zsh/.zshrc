#!/bin/zsh
echo ".zshrc loaded"
setopt ignore_eof

export GIT_CONFIG_GLOBAL="$HOME/.config/git/.gitconfig"
export GIT_EDITOR="nvim"
export GPG_TTY=$(tty)

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if grep -qi microsoft /proc/version 2>/dev/null; then
  alias fd="fdfind"
fi

eval "$(mise activate zsh)"

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.json)"
fi

autoload -Uz compinit
compinit

source "$HOME/.config/fzf/fzf.zsh"

# Auto-start tmux
if [[ -z "$TMUX" && $- == *i* ]]; then
  exec tmux
fi
