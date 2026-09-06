export XDG_CONFIG_HOME=$HOME/.config
export EDITOR="nvim"
export DOTFILES="$HOME/.dotfiles"

typeset -U path
path=(
  $HOME/.local/bin
  $HOME/bin
  $HOME/.foundry/bin
  $HOME/.opencode/bin
  $HOME/.local/share/solana/install/active_release/bin
  $path
)
if [[ "$(uname -s)" == "Darwin" ]]; then
  path=(
    /Applications/Blender.app/Contents/MacOS
    $path
  )
fi
export PATH
