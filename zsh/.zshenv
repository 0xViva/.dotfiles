#!/bin/zsh
export PATH="$PATH:/Users/august/.foundry/bin"
export PATH=/home/august/.opencode/bin:$PATH

if [ ! -f /etc/arch-release ] && [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
