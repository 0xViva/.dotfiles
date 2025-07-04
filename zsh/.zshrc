#!/bin/zsh


if [[ "$(uname -s)" == "Darwin" ]]; then
  OS_TYPE="macos"
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  OS_TYPE="wsl"
elif [[ -f /etc/arch-release ]]; then
  OS_TYPE="arch"
  autoload -Uz compinit
  compinit
else
  OS_TYPE="unknown"
fi

export DOTFILES="$HOME/.dotfiles"
if [[ -x "$DOTFILES/OS/${OS_TYPE}" ]]; then
    source "$DOTFILES/OS/${OS_TYPE}"
    STOW_FOLDERS=$STOW_FOLDERS
fi

export PATH=$PATH:.local/bin
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PWD/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.foundry/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

export GIT_CONFIG_GLOBAL="$HOME/.dotfiles/git/.gitconfig"
export GPG_TTY=$(tty)
export GOPATH="$HOME/go"


if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

fzf-cd-widget() {
  local dir
  dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) || return
  cd "$dir" || return
  zle reset-prompt
  zle accept-line
}
zle -N fzf-cd-widget
bindkey '^T' fzf-cd-widget

fzf-nvim-widget() {
  local dir
  dir=$(find ~/code/personal ~/code/public -mindepth 1 -maxdepth 1 -type d | fzf +m) || return
  nvim "$dir" || return 
  zle reset-prompt
  zle accept-line
}
zle -N fzf-nvim-widget
bindkey '^N' fzf-nvim-widget

# Bun shell completions
if [[ -s "$HOME/.bun/_bun" ]]; then
  source "$HOME/.bun/_bun"
fi
export IGNOREEOF=0
