#!/bin/zsh

GPG_CONF="$HOME/.gnupg/gpg-agent.conf"
LOCAL_GITCONFIG="$HOME/.gitconfig.local"

mkdir -p ~/.gnupg

if [[ "$OSTYPE" == "darwin"* ]]; then
    PINENTRY_PATH="/opt/homebrew/bin/pinentry-curses"
    SED_INPLACE=("sed" "-i" "")
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PINENTRY_PATH="/usr/bin/pinentry-curses"
    SED_INPLACE=("sed" "-i")
else
    echo "Unsupported OS for GPG pinentry setup"
    exit 1
fi

if [[ -f "$GPG_CONF" ]] && grep -q "^pinentry-program" "$GPG_CONF"; then
    "${SED_INPLACE[@]}" "s|^pinentry-program.*|pinentry-program $PINENTRY_PATH|" "$GPG_CONF"
else
    echo "pinentry-program $PINENTRY_PATH" >> "$GPG_CONF"
fi
git config --file "$LOCAL_GITCONFIG" gpg.program "$(realpath ~/.dotfiles/bin/gpg-fugitive)"

gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
