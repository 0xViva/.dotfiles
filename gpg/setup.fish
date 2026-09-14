#!/usr/bin/env fish
# Configure the GPG pinentry program and point git at the platform gpg binary.

set -l gpg_conf $HOME/.gnupg/gpg-agent.conf
set -l local_gitconfig $HOME/.gitconfig.local

mkdir -p $HOME/.gnupg; or exit 1

set -l pinentry_path
set -l gpg_path
set -l sed_inplace
switch (uname -s)
    case Darwin
        set pinentry_path /opt/homebrew/bin/pinentry-curses
        set gpg_path /opt/homebrew/bin/gpg
        set sed_inplace sed -i ''
    case Linux
        set pinentry_path /usr/bin/pinentry-curses
        set gpg_path /usr/bin/gpg
        set sed_inplace sed -i
    case '*'
        echo "Unsupported OS for GPG pinentry setup" >&2
        exit 1
end

if test -f "$gpg_conf"; and grep -q "^pinentry-program" "$gpg_conf"
    $sed_inplace "s|^pinentry-program.*|pinentry-program $pinentry_path|" "$gpg_conf"; or exit 1
else
    echo "pinentry-program $pinentry_path" >> "$gpg_conf"
end

git config --file "$local_gitconfig" gpg.program $gpg_path; or exit 1

gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
