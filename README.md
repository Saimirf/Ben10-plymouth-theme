# Ben10 Plymouth Theme

A custom Plymouth boot splash theme featuring Ben10 animations displayed during system startup.

---

## Preview

![Ben10 Plymouth Theme](preview.gif)

actuall images are much sharper
---

## Requirements

- Linux (Debian/Ubuntu based distros recommended)
- Plymouth installed
- Root/sudo access

Install Plymouth if you don't have it:
```bash
sudo apt install plymouth plymouth-themes
```

---

## Installation

### Option 1 — Automatic (Recommended)

Clone the repo and run the installer:

```bash
git clone https://github.com/yourusername/ben10-plymouth-theme.git
cd ben10-plymouth-theme
sudo bash install.sh
```

Reboot to see the theme:
```bash
reboot
```

### Option 2 — Manual

```bash
# Copy theme files
sudo cp -r ben10 /usr/share/plymouth/themes/

# Set as default
sudo plymouth-set-default-theme -R ben10

# Update initramfs
sudo update-initramfs -u

# Reboot
reboot
```

---

## Uninstall

```bash
# Set back to default theme
sudo plymouth-set-default-theme -R default

# Remove theme files
sudo rm -rf /usr/share/plymouth/themes/ben10

# Update initramfs
sudo update-initramfs -u
```

---

## Testing Without Rebooting

You can preview the theme without rebooting:

```bash
sudo plymouthd
sudo plymouth --show-splash
sleep 5
sudo plymouth quit
```

---

## Troubleshooting

**Theme not showing after reboot**
Make sure initramfs was updated:
```bash
sudo update-initramfs -u
```

**Plymouth not installed**
```bash
sudo apt install plymouth
```

**Check current theme**
```bash
plymouth-set-default-theme
```

---

## License

This theme is free to use and modify. If you share or build on it, a credit would be appreciated.
