#!/bin/bash
# Set strict error handling (script exits on errors)
set -e

sudo nano /etc/nixos/hosts/default/configuration.nix

# Rebuild the system with flake configuration
sudo nixos-rebuild switch --flake /etc/nixos#default

# Navigate to your NixOS configuration directory (replace with your actual path)
cd /etc/nixos

cp -r * /home/ate329/nixconf/my-nixos-configuration/

cd /home/ate329/nixconf/my-nixos-configuration

# Git commands (assuming you have Git installed and configured)
git pull
git add .

# Prompt for commit message with default
read -p "Enter commit message (default: Change system config): " commit_message

# Set default message if user enters nothing
if [[ -z "$commit_message" ]]; then
  commit_message="Change system config"
fi

git commit -m "$commit_message"
git diff

# Push changes to remote repository on GitHub (replace with your details)
git push

echo "Rebuild complete and pushed to GitHub!"


