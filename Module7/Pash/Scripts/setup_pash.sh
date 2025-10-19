#!/usr/bin/env bash

# ------------------------------------------------------------
# Script Name: Setup pash
# Author:      Esteban Herrera Castro
# Email:       stv.herrera@gmail.com
# Date:        10/09/2025
# ------------------------------------------------------------
# Description:
# setup_pash.sh — Automated setup for Pash (by Dylan Araps)
# Works on Debian/Ubuntu and most Linux systems.
#
# Steps:
# Installs all dependencies (git, gnupg, xclip)
# Downloads and installs Pash
# Checks for an existing GPG key, or helps you create one
# Creates the Pash config and environment setup
# Finishes with a working installation
#
# After running, you’ll have:
# Pash installed system-wide
# Your GPG key automatically configured
# A working setup under ~/.local/share/pash/
# Environment variables auto-loaded in new shells

set -e

# --- Step 1: Install dependencies ---
echo "[1/5] Installing dependencies..."
if command -v apt >/dev/null 2>&1; then
    sudo apt update -y
    sudo apt install -y git gnupg xclip
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm git gnupg xclip
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y git gnupg2 xclip
else
    echo "Unsupported package manager. Please install git, gnupg, and xclip manually."
    exit 1
fi

# --- Step 2: Install Pash ---
echo "[2/5] Installing Pash..."
if [ ! -d "$HOME/pash" ]; then
    git clone https://github.com/dylanaraps/pash.git "$HOME/pash"
fi

sudo install -m 755 "$HOME/pash/pash" /usr/local/bin/pash
echo "Pash installed at /usr/local/bin/pash."

# --- Step 3: Detect or create GPG key ---
echo "[3/5] Checking for GPG keys..."
if gpg --list-keys | grep -q '^pub'; then
    echo "Existing GPG key(s) found:"
    gpg --list-keys --keyid-format LONG
    echo
    read -p "Enter your GPG Key ID (leave empty to use the first one): " PASH_KEYID
    if [ -z "$PASH_KEYID" ]; then
        PASH_KEYID=$(gpg --list-keys --keyid-format LONG | grep '^pub' | head -n1 | awk '{print $2}' | cut -d'/' -f2)
    fi
else
    echo "No GPG keys found — creating one now..."
    gpg --batch --gen-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Name-Real: $(whoami)
Name-Email: $(whoami)@$(hostname)
Expire-Date: 0
EOF
    PASH_KEYID=$(gpg --list-keys --keyid-format LONG | grep '^pub' | head -n1 | awk '{print $2}' | cut -d'/' -f2)
fi

echo "Using GPG key ID: $PASH_KEYID"

# --- Step 4: Configure Pash ---
echo "[4/5] Setting up configuration..."
mkdir -p ~/.config/pash
mkdir -p ~/.local/share/pash

cat > ~/.config/pash/env.sh <<EOF
# Pash environment configuration
export PASH_KEYID="$PASH_KEYID"
export PASH_DIR="\$HOME/.local/share/pash"
export PASH_CLIP="xclip -selection clipboard"
export PASH_TIMEOUT=15
export PASH_LENGTH=50
EOF

# Add to bashrc if not already present
if ! grep -q "pash/env.sh" ~/.bashrc 2>/dev/null; then
    echo 'source ~/.config/pash/env.sh' >> ~/.bashrc
fi

echo "Pash configuration created at ~/.config/pash/env.sh"

# --- Step 5: Test installation ---
echo "[5/5] Testing Pash installation..."
source ~/.config/pash/env.sh

echo
echo "Pash is now ready! 🎉"
echo
echo "Try these commands next:"
echo "  pash add testsite/account"
echo "  pash list"
echo "  pash show testsite/account"
echo "  pash tree"
echo
echo "Your encrypted passwords will be stored in: $PASH_DIR"
echo
