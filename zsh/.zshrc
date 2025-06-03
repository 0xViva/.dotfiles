VIM="nvim"

echo "Starting .zshrc"
OS_TYPE=""
if [[ "$(uname -s)" == "Darwin" ]]; then
  OS_TYPE="macOS"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  OS_TYPE="WSL"
elif [[ "$(uname -s)" == "Linux" ]]; then
  OS_TYPE="Linux"
else
  OS_TYPE="Unknown"
fi

case "$OS_TYPE" in
  "macOS")
    echo "Running homebrew for $OS_TYPE"
    [[ -x "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
  "WSL"|"Linux")
    echo "Running homebrew for $OS_TYPE"
    [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ;;
esac

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"

export DOTFILES=$HOME/.dotfiles
export STOW_FOLDERS="ghostty,nvim,oh-my-posh,sketchybar,skhd,yabai,zsh"
export GPG_TTY=$(tty)
export LUA_PATH="/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;;"
export LUA_CPATH="/opt/homebrew/lib/lua/5.4/?.so;;"
export GOPATH=$HOME/go
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="$HOME/.foundry/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

source <(fzf --zsh)

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# bun completions
[ -s "/Users/august/.bun/_bun" ] && source "/Users/august/.bun/_bun"

