
#!/bin/zsh
GPG_CONF="$HOME/.gnupg/gpg-agent.conf"

mkdir -p ~/.gnupg

if [[ "$OSTYPE" == "darwin"* ]]; then
    PINENTRY_PATH="/opt/homebrew/bin/pinentry-curses"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PINENTRY_PATH="/usr/bin/pinentry-curses"
else
    echo "Unsupported OS for GPG pinentry setup"
    exit 1
fi

# Update or add pinentry-program line
if grep -q "^pinentry-program" "$GPG_CONF" 2>/dev/null; then
    sed -i '' "s|^pinentry-program.*|pinentry-program $PINENTRY_PATH|" "$GPG_CONF"
else
    echo "pinentry-program $PINENTRY_PATH" >> "$GPG_CONF"
fi

# Restart gpg-agent
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
