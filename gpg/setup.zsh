#!/bin/zsh

GPG_CONF="$HOME/.gnupg/gpg-agent.conf"

mkdir -p ~/.gnupg

if [[ "$OSTYPE" == "darwin"* ]]; then
    PINENTRY_PATH="/opt/homebrew/bin/pinentry-curses"
    SED_INPLACE=("sed" "-i" "")  # BSD sed requires an empty string after -i
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PINENTRY_PATH="/usr/bin/pinentry-curses"
    SED_INPLACE=("sed" "-i")  # GNU sed doesn't take empty string
else
    echo "Unsupported OS for GPG pinentry setup"
    exit 1
fi

# Update or add pinentry-program line
if [[ -f "$GPG_CONF" ]] && grep -q "^pinentry-program" "$GPG_CONF"; then
    "${SED_INPLACE[@]}" "s|^pinentry-program.*|pinentry-program $PINENTRY_PATH|" "$GPG_CONF"
else
    echo "pinentry-program $PINENTRY_PATH" >> "$GPG_CONF"
fi
git config --global gpg.program "$(realpath ~/.dotfiles/bin/gpg-fugitive)"

# Restart gpg-agent
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
