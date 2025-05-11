
VIM="nvim"

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"

export DOTFILES=$HOME/.dotfiles
export LUA_PATH="/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;;"
export LUA_CPATH="/opt/homebrew/lib/lua/5.4/?.so;;"
export GOPATH=$HOME/go

eval $(/opt/homebrew/bin/brew shellenv)
