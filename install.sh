#!/bin/bash
# Ben10 Plymouth Theme Installer (Linux Mint Compatible)
set -e

THEME_NAME="ben10"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_THEME="$SCRIPT_DIR/ben10"
DEST_THEME="/usr/share/plymouth/themes/ben10"

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo bash install.sh"
  exit 1
fi

echo "================================"
echo "  Ben10 Plymouth Theme Installer"
echo "================================"

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

# Create destination directory
echo "[1/3] Copying ben10 theme files to /usr/share/plymouth/themes/ben10/..."
mkdir -p "$DEST_THEME"

# Copy only the contents of ben10 folder (not the folder itself)
cp -r "$SOURCE_THEME"/* "$DEST_THEME"/

# Also copy hidden files if any exist
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

# Set as default plymouth theme
echo "[2/3] Setting $THEME_NAME as default plymouth theme..."
if command -v plymouth-set-default-theme &> /dev/null; then
    plymouth-set-default-theme "$THEME_NAME"
else
    echo "Using update-alternatives method..."
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth \
        "$PLYMOUTH_FILE" 100
    update-alternatives --set default.plymouth "$PLYMOUTH_FILE"
fi

# Update initramfs (Linux Mint compatible)
echo "[3/3] Updating initramfs..."
if command -v update-initramfs &> /dev/null; then
    update-initramfs -u
elif command -v dracut &> /dev/null; then
    dracut -f
else
    echo "Warning: Could not find update-initramfs or dracut"
fi

echo ""
echo "✓ Ben10 Plymouth theme installed successfully!"
echo "  Restart your computer to see the theme."
echo ""

