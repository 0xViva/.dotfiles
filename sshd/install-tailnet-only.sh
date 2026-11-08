#!/bin/bash
# Apply the sshd key-only drop-in and the tailscale0-only SSH firewall rule.
# Run as root: sudo ~/.dotfiles/sshd/install-tailnet-only.sh
set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo: sudo $0" >&2
    exit 1
fi

echo "Installing sshd key-only drop-in..."
install -Dm644 "$DOTFILES/sshd/00-dotfiles.conf" \
    /etc/ssh/sshd_config.d/00-dotfiles.conf

if ! sshd -t; then
    echo "sshd config test failed; removing the new drop-in" >&2
    rm -f /etc/ssh/sshd_config.d/00-dotfiles.conf
    exit 1
fi

echo "Installing tailscale0-only SSH firewall rule..."
install -Dm644 "$DOTFILES/sshd/sshd-tailnet.nft" \
    /etc/nftables.d/sshd-tailnet.nft
install -Dm644 "$DOTFILES/sshd/sshd-tailnet-firewall.service" \
    /etc/systemd/system/sshd-tailnet-firewall.service

systemctl daemon-reload
systemctl enable --now sshd-tailnet-firewall.service
systemctl reload sshd

echo
echo "Applied. Effective settings:"
sshd -T | grep -E '^(passwordauthentication|permitrootlogin|allowusers|authenticationmethods|kbdinteractiveauthentication)'
echo
nft list table inet ssh_tailnet
echo
systemctl --no-pager --lines=0 status sshd-tailnet-firewall.service
