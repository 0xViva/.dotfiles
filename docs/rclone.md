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

Each run copies the entire drive into a fresh timestamped
`google-drive_<date>_<time>` snapshot. Once the copy succeeds, older snapshots
are pruned so only the newest `RCLONE_BACKUP_KEEP` remain (default 2; set it to
`0` to keep everything). Snapshots live under `$HOME`, which is btrfs mounted
`compress=zstd:3`, so they are compressed at rest automatically.

Override the destination with `RCLONE_BACKUP_ROOT`, e.g.
`env RCLONE_BACKUP_ROOT=/mnt/disk/google_drive rclone-backup`.

### Keeping the desktop responsive

Snapshots are written to the same disk the system runs on, so an unthrottled
copy can starve the desktop. The copy is therefore rate-limited to
`RCLONE_BACKUP_BWLIMIT` (default `50M`) and run with limited concurrency
(`--transfers 2 --checkers 4`). `rclone-backup.service` additionally runs at
idle I/O priority and low CPU/memory weight. Raise or remove the cap with e.g.
`RCLONE_BACKUP_BWLIMIT=200M`, or `0` for no limit.

### Schedule

`rclone-backup.timer` runs the backup monthly (`OnCalendar=monthly`) and is
enabled by `setup.sh`. It triggers `rclone-backup.service`, a `Type=oneshot`
unit, at the start of each month:

```fish
systemctl --user list-timers rclone-backup.timer
journalctl --user -u rclone-backup.service     # run log
```

`Persistent=true` means a run missed while the machine was off happens at the
next opportunity rather than being skipped. To run a snapshot immediately:

```fish
systemctl --user start rclone-backup.service
```
