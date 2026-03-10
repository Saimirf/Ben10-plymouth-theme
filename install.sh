#!/bin/bash

# Ben10 Plymouth Theme Installer

set -e

THEME_NAME="ben10"
THEME_DIR="$(dirname "$(realpath "$0")")"
INSTALL_DIR="/usr/share/plymouth/themes/$THEME_NAME"

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo bash install.sh"
  exit 1
fi

echo "================================"
echo "  Ben10 Plymouth Theme Installer"
echo "================================"

# Copy theme files
echo "[1/3] Copying theme files to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
cp -r "$THEME_DIR"/. "$INSTALL_DIR/"

# Remove the installer itself from the theme directory
rm -f "$INSTALL_DIR/install.sh"
rm -f "$INSTALL_DIR/README.md"

# Set as default plymouth theme
echo "[2/3] Setting $THEME_NAME as default plymouth theme..."
plymouth-set-default-theme -R "$THEME_NAME"

# Update initramfs
echo "[3/3] Updating initramfs..."
update-initramfs -u

echo ""
echo "✓ Ben10 Plymouth theme installed successfully!"
echo "  Restart your computer to see the theme."
