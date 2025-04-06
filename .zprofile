eval $(/opt/homebrew/bin/brew shellenv)
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME:$PATH"
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin
