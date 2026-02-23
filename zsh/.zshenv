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
    /opt/zerobrew/prefix/bin
    $path
  )
fi
export PATH

case "$(uname -s)" in
  Darwin)  OS_TYPE="macos" ;;
  Linux)   OS_TYPE="linux" ;;
  *)       OS_TYPE="unknown" ;;
esac

OS_FILE="$DOTFILES/OS/$OS_TYPE"

if [[ -f "$OS_FILE" ]]; then
  source "$OS_FILE"
fi
