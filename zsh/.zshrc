#!/bin/zsh
echo ".zshrc loaded"
setopt ignore_eof

if [[ "$(uname -s)" == "Darwin" ]]; then
  OS_TYPE="macos"
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  OS_TYPE="wsl"
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

eval "$(mise activate zsh)"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH=$PATH:/usr/bin
export PATH="$HOME/bin:$PATH"
export PATH="$PWD/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.foundry/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export FLYCTL_INSTALL="/home/august/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#alias
alias claude="/home/august/.claude/local/claude"
alias todo="~/go/bin/godoit"
alias fd="fdfind"
# commands to run:
#godoit -l
