#!/bin/bash
# Set strict error handling (script exits on errors)
set -e

sudo nixos-rebuild switch --flake /etc/nixos#default --upgrade
sudo nixos-rebuild switch --flake /etc/nixos#default

cd /home/ate329/nixconf/my-nixos-configuration

git pull
git add .

# Prompt for commit message with default
read -p "Enter commit message (default: Update and rebuild the system): " commit_message

# Set default message if user enters nothing
if [[ -z "$commit_message" ]]; then
  commit_message="Update and rebuild the system"
fi

git commit -m "$commit_message"

git diff
git push

echo "Rebuild and update completed and pushed to Github"
