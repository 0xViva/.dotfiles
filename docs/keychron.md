# Fixing Keychron HID Device Connection Issue on Linux

> The udev rule in `udev/rules.d/99-keychron.rules` is installed automatically by
> `./setup.sh arch`. This guide is only needed if the launcher still can't connect.

If your **Keychron keyboard** shows **HID device connected** when you try to connect
the keyboard with the **Keychron Launcher**, follow the steps below to fix it.

## 1. Add User to Input Group

```bash
sudo usermod -aG input $USER
```

## 2. Create/Edit the udev Rule

```bash
sudo vim /etc/udev/rules.d/99-keychron.rules
```

Add (modify `idProduct` and `GROUP`):
```bash
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0660", GROUP="myusername", TAG+="uaccess", TAG+="udev-acl"
```

## 3. Find Your idProduct

```bash
lsusb | grep Keychron
```
Output like `ID 3434:d030` → `idVendor=3434`, `idProduct=d030`.

## 4. Reload udev Rules

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

## 5. If It Still Doesn't Work

Relax permissions temporarily:
```bash
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
```

## Notes

- `MODE="0666"` is less secure — for testing only.
- Always reload udev rules after editing, or nothing applies.