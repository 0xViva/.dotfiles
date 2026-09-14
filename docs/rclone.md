# rclone (Google Drive)

Google Drive is exposed two ways:

- **Network mount** — the `rclone-drive.service` systemd user unit mounts the
  `gdrive` remote at `~/GoogleDrive`, where Nautilus shows it.
- **Backup** — `bin/rclone-backup` snapshots the whole remote one-way into
  `~/backups/google_drive/google-drive_<date>_<time>`.

rclone never reads or writes a config file here: it is always invoked with
`--config=` and gets everything from the environment. Non-secret settings live
in `rclone/rclone.env`; the OAuth secrets live in the repo-root `.env`, which is
gitignored. This is deliberate — rclone writes refreshed tokens back into any
config file it can open, so a tracked config would leak secrets into git.

## One-time setup

1. Create your own Google OAuth client (rclone's shared client_id is being
   retired during 2026):
   - <https://console.cloud.google.com> → new project → enable the
     **Google Drive API**.
   - OAuth consent screen → External → add yourself as a test user.
   - Credentials → Create OAuth client ID → **Desktop app** (loopback
     redirects are allowed automatically; if you pick *Web application*
     instead, register `http://127.0.0.1:53682/`).

2. Authorize and capture the token:

   ```fish
   rclone authorize drive <CLIENT_ID> <CLIENT_SECRET>
   ```

   A browser opens; on success rclone prints a JSON token blob.

3. Create `.env` from the template and fill it in:

   ```fish
   cp .env.example .env
   ```

   Paste the client id/secret and the token blob (one line, single-quoted).

## Mount

```fish
systemctl --user enable --now rclone-drive.service   # mount now and at login
systemctl --user status rclone-drive.service
journalctl --user -u rclone-drive.service -f
```

Browse to `~/GoogleDrive`. Stop it with
`systemctl --user stop rclone-drive.service`.

## Backup

```fish
rclone-backup
```

Each run copies the entire drive into a fresh timestamped snapshot and never
deletes anything. Override the destination with `RCLONE_BACKUP_ROOT`, e.g.
`env RCLONE_BACKUP_ROOT=/mnt/disk/google_drive rclone-backup`.
