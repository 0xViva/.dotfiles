#!/bin/zsh

export EDITOR="nvim"
export DOTFILES="$HOME/.dotfiles"

typeset -U path

# Base paths (always)
path=(
  $HOME/.local/bin
  $HOME/bin
  $HOME/.foundry/bin
  $HOME/.opencode/bin
  $HOME/.local/share/solana/install/active_release/bin
  $path
)

# macOS-only additions
if [[ "$(uname -s)" == "Darwin" ]]; then
  path=(
    /Applications/Blender.app/Contents/MacOS
    /opt/zerobrew/prefix/bin
    $path
  )
fi

export PATH
