VIM="nvim"
echo "Running .zshrc"
OS_TYPE=""
if [[ "$(uname -s)" == "Darwin" ]]; then
  OS_TYPE="macos"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  OS_TYPE="wsl"
elif [[ -f /etc/arch-release ]]; then
  OS_TYPE="arch"
else
  OS_TYPE="Unknown"
fi
case "$OS_TYPE" in
  "macOS")
[[ -x "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "Running homebrew for $OS_TYPE"
    export LUA_PATH="/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;;"
    export LUA_CPATH="/opt/homebrew/lib/lua/5.4/?.so;;"
    STOW_FOLDERS="$($HOME/.dotfiles/OS/${OS_TYPE})"

    ;;
  "wsl"|"arch")
    echo "Running homebrew for $OS_TYPE"
     [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export PATH="/home/linuxbrew/.linuxbrew/opt/rustup/bin:$PATH"
    export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
    STOW_FOLDERS="$($HOME/.dotfiles/OS/${OS_TYPE})"

    ;;
esac

echo "Run exports..."
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"
export PATH="$HOME/bin:$PATH"
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
