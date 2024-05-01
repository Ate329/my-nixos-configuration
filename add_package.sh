#!/bin/bash
# Set strict error handling (script exits on errors)
set -e

sudo nano /etc/nixos/modules/packages.nix

# Rebuild the system with flake configuration
sudo nixos-rebuild switch --flake /etc/nixos#default

# Navigate to your NixOS configuration directory (replace with your actual path)
cd /etc/nixos

cp -r * /home/ate329/nixconf/my-nixos-configuration/

cd /home/ate329/nixconf/my-nixos-configuration

# Git commands (assuming you have Git installed and configured)
git pull
git add .
git commit -m "NixOS rebuild with flakes"
git diff

# Push changes to remote repository on GitHub (replace with your details)
git push

echo "Rebuild complete and pushed to GitHub!"

