#!/bin/zsh
echo ".zshrc loaded"
setopt ignore_eof

if [[ "$(uname -s)" == "Darwin" ]]; then
  OS_TYPE="macos"
  export PATH="/Applications/Blender.app/Contents/MacOS:$PATH"
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  export PATH="/opt/zerobrew/prefix/bin:$PATH"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  OS_TYPE="wsl"
  alias fd="fdfind"
elif [[ -f /etc/arch-release ]]; then
  OS_TYPE="arch"
else
  OS_TYPE="unknown"
fi

autoload -Uz compinit
compinit

export DOTFILES="$HOME/.dotfiles"
if [[ -x "$DOTFILES/OS/${OS_TYPE}" ]]; then
    source "$DOTFILES/OS/${OS_TYPE}"
    STOW_FOLDERS=$STOW_FOLDERS
fi

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH=/home/ajg/.opencode/bin:$PATH

eval "$(mise activate zsh)"


export GIT_CONFIG_GLOBAL="$HOME/.config/git/.gitconfig"
export GPG_TTY=$(tty)

  if command -v oh-my-posh >/dev/null 2>&1; then
    eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.json)"
  fi

source "$HOME/.config/fzf/fzf.zsh"

# Bun shell completions
if [[ -s "$HOME/.bun/_bun" ]]; then
  source "$HOME/.bun/_bun"
fi


#alias
alias claude="/home/august/.claude/local/claude"
alias todo="~/go/bin/godoit"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
