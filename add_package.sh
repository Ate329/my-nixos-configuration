#!/bin/bash
# Set strict error handling (script exits on errors)
set -e

# Edit NixOS packages file
sudo nano /etc/nixos/modules/packages.nix

# Rebuild the system with flake configuration
sudo nixos-rebuild switch --flake /etc/nixos#default

# Navigate to your NixOS configuration directory
cd /etc/nixos

# Backup configuration (optional, consider adding version control)
cp -r * /home/ate329/nixconf/my-nixos-configuration/

cd /home/ate329/nixconf/my-nixos-configuration

# Git commands
git pull
git add .

# Prompt for commit message with default
read -p "Enter commit message (default: Add/Remove packages): " commit_message

# Set default message if user enters nothing
if [[ -z "$commit_message" ]]; then
  commit_message="Add/Remove packages"
fi

git commit -m "$commit_message"
git diff

# Push changes to remote repository (replace with your details)
git push

echo "Action complete and pushed to GitHub!"
