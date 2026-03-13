#!/bin/bash
# Ben10 Plymouth Theme Installer
# EndeavourOS Dual Boot (dracut + GRUB on Windows EFI partition)
set -e

THEME_NAME="ben10"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_THEME="$SCRIPT_DIR/ben10"
DEST_THEME="/usr/share/plymouth/themes/ben10"
GRUB_CFG_PATH="/boot/grub/grub.cfg"
GRUB_DEFAULTS="/etc/default/grub"

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo bash install.sh"
  exit 1
fi

echo "================================"
echo "  Ben10 Plymouth Theme Installer"
echo "  EndeavourOS Dual Boot Edition "
echo "================================"

# Detect distro
DISTRO=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID"
    DISTRO_LIKE="$ID_LIKE"
fi
echo "Detected distro: $DISTRO"

# Install plymouth if missing
if ! command -v plymouth-set-default-theme &> /dev/null; then
    if [[ "$DISTRO" == "endeavouros" || "$DISTRO_LIKE" == *"arch"* ]]; then
        echo "Installing plymouth via pacman..."
        pacman -Sy --noconfirm plymouth
    fi
fi

# Check if source ben10 folder exists
if [ ! -d "$SOURCE_THEME" ]; then
    echo "Error: ben10 folder not found at $SOURCE_THEME"
    echo "Please ensure install.sh and ben10 folder are in the same directory"
    exit 1
fi

# Remove existing installation if present
if [ -d "$DEST_THEME" ]; then
    echo "Removing existing installation..."
    rm -rf "$DEST_THEME"
fi

# [1/5] Copy theme files
echo "[1/5] Copying ben10 theme files..."
mkdir -p "$DEST_THEME"
cp -r "$SOURCE_THEME"/* "$DEST_THEME"/
if ls "$SOURCE_THEME"/.[!.]* 1> /dev/null 2>&1; then
    cp -r "$SOURCE_THEME"/.[!.]* "$DEST_THEME"/
fi
echo "Theme files copied to $DEST_THEME"

# Find the .plymouth file
PLYMOUTH_FILE=$(find "$DEST_THEME" -maxdepth 1 -name "*.plymouth" -type f | head -n 1)
if [ -z "$PLYMOUTH_FILE" ]; then
    echo "Error: No .plymouth file found in ben10 folder"
    exit 1
fi
echo "Found Plymouth config: $PLYMOUTH_FILE"

# [2/5] Set default plymouth theme
echo "[2/5] Setting $THEME_NAME as default plymouth theme..."
if command -v plymouth-set-default-theme &> /dev/null; then
    plymouth-set-default-theme "$THEME_NAME"
else
    echo "Using update-alternatives method..."
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth \
        "$PLYMOUTH_FILE" 100
    update-alternatives --set default.plymouth "$PLYMOUTH_FILE"
fi

# [3/5] Configure GRUB
echo "[3/5] Configuring GRUB..."
if [ -f "$GRUB_DEFAULTS" ]; then
    # Add splash if not present
    if ! grep -q "splash" "$GRUB_DEFAULTS"; then
        echo "Adding 'splash' to GRUB cmdline..."
        sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT='\(.*\)'/GRUB_CMDLINE_LINUX_DEFAULT='\1 splash'/" "$GRUB_DEFAULTS"
    else
        echo "Splash already present in GRUB cmdline, skipping."
    fi

    # Enable os-prober for Windows detection
    if grep -q "#GRUB_DISABLE_OS_PROBER=false" "$GRUB_DEFAULTS"; then
        echo "Enabling os-prober for Windows detection..."
        sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' "$GRUB_DEFAULTS"
    fi

    echo "Regenerating GRUB config..."
    grub-mkconfig -o "$GRUB_CFG_PATH"
else
    echo "Warning: $GRUB_DEFAULTS not found, skipping GRUB configuration."
fi

# [4/5] Configure dracut for plymouth
echo "[4/5] Configuring dracut..."

# Disable UEFI output mode to prevent EFI path errors
if [ ! -f /etc/dracut.conf.d/no-uefi.conf ]; then
    echo "Disabling dracut UEFI output mode..."
    echo 'uefi="no"' > /etc/dracut.conf.d/no-uefi.conf
fi

# Add plymouth module to dracut
if [ ! -f /etc/dracut.conf.d/plymouth.conf ]; then
    echo "Adding plymouth module to dracut..."
    echo 'add_dracutmodules+=" plymouth "' > /etc/dracut.conf.d/plymouth.conf
fi

# [5/5] Rebuild initramfs
echo "[5/5] Rebuilding initramfs..."
KERNEL_VER=$(uname -r)
dracut -f --kver "$KERNEL_VER" /boot/initramfs-linux.img
dracut -f --kver "$KERNEL_VER" /boot/initramfs-linux-fallback.img --no-hostonly

# Final GRUB regeneration after initramfs rebuild
echo "Final GRUB config regeneration..."
grub-mkconfig -o "$GRUB_CFG_PATH"

echo ""
echo "✓ Ben10 Plymouth theme installed successfully!"
echo "  Restart your computer to see the theme."
echo ""
