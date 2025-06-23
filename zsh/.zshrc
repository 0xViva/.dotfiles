VIM="nvim"

echo "Running .zshrc"
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
    export LUA_PATH="/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;;"
    export LUA_CPATH="/opt/homebrew/lib/lua/5.4/?.so;;"
export STOW_FOLDERS="ghostty,nvim,oh-my-posh,sketchybar,skhd,yabai,zsh,git"

    ;;
  "WSL"|"Linux")
    echo "Running homebrew for $OS_TYPE"
    export PATH="/home/linuxbrew/.linuxbrew/opt/rustup/bin:$PATH"
    export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export STOW_FOLDERS="nvim,oh-my-posh,zsh,git"
    ;;
esac

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"

echo "Run exports..."
export DOTFILES=$HOME/.dotfiles
export GIT_CONFIG_GLOBAL="$HOME/.dotfiles/git/.gitconfig"
export GPG_TTY=$(tty)
export GOPATH=$HOME/go
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.foundry/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
echo "Source fzf for zsh..."
source <(fzf --zsh)
echo "make yazi available at function y()..."
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# bun completions
[ -s "/Users/august/.bun/_bun" ] && source "/Users/august/.bun/_bun"


. "$HOME/.local/bin/env"
