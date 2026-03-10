# Ben10 Plymouth Theme
A custom Plymouth boot splash theme featuring Ben10 animations displayed during system startup.

---

## Preview
![Ben10 Plymouth Theme](preview.gif)

*Actual images are much sharper*

---

## Requirements
- Linux (Debian/Ubuntu/Linux Mint based distros)
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
git clone https://github.com/Saimirf/Ben10-plymouth-theme.git
cd ben10-plymouth-theme
sudo bash install.sh
```
make sure these lines are in /etc/default/grub
```
sudo nano /etc/default/grub
```
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""
```

Reboot to see the theme:
```bash
reboot
```

### Option 2 — Manual

**For Ubuntu/Debian/Pop!_OS/Zorin OS/elementary OS:**
```bash
# Copy theme folder to Plymouth themes directory
sudo cp -r ben10 /usr/share/plymouth/themes/

# Set as default theme
sudo plymouth-set-default-theme ben10

# Update initramfs
sudo update-initramfs -u

# Reboot to see the theme
reboot
```

**For Linux Mint/LMDE:**
```bash
# Copy theme folder to Plymouth themes directory
sudo cp -r ben10 /usr/share/plymouth/themes/

# Set as default theme using update-alternatives
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth \
    /usr/share/plymouth/themes/ben10/ben10.plymouth 100
sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/ben10/ben10.plymouth

# Update initramfs
sudo update-initramfs -u

# Reboot to see the theme
reboot
```

## Troubleshooting

**Theme not showing after reboot**

Make sure initramfs was updated:
```bash
sudo update-initramfs -u
```

**Verify the theme is set as default:**

*Ubuntu/Debian/Pop!_OS/Zorin OS/elementary OS:*
```bash
plymouth-set-default-theme
```

*Linux Mint/LMDE:*
```bash
update-alternatives --display default.plymouth
```

**List all available themes:**

*Ubuntu/Debian/Pop!_OS/Zorin OS/elementary OS:*
```bash
plymouth-set-default-theme --list
```

*Linux Mint/LMDE:*
```bash
update-alternatives --list default.plymouth
```
*Switch between available themes through list in Mint*
```bash
sudo update-alternatives --config default.plymouth
```

**Check if theme files exist:**
```bash
ls -la /usr/share/plymouth/themes/ben10/
```

**Plymouth not installed:**
```bash
sudo apt install plymouth plymouth-themes
```
---

## Uninstall

**For Ubuntu/Debian/Pop!_OS/Zorin OS/elementary OS:**
```bash
# Set back to default theme
sudo plymouth-set-default-theme default

# Remove theme files
sudo rm -rf /usr/share/plymouth/themes/ben10

# Update initramfs
sudo update-initramfs -u
```

**For Linux Mint/LMDE:**
```bash
# Set back to default theme using update-alternatives
sudo update-alternatives --config default.plymouth
# (Select 'default' or another theme from the list)

# Or set a specific theme directly:
sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/default/default.plymouth

# Remove theme files
sudo rm -rf /usr/share/plymouth/themes/ben10

# Update initramfs
sudo update-initramfs -u
```
---

## Credits

Ben10 and related characters are property of Cartoon Network. This is a fan-made theme for personal use.

---

## License

This theme is free to use and modify. If you share or build on it, a credit would be appreciated.
