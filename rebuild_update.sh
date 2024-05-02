#!/bin/bash
# Set strict error handling (script exits on errors)
set -e

sudo nixos-rebuild switch --flake /etc/nixos#default --upgrade
sudo nixos-rebuild switch --flake /etc/nixos#default

git pull
git add .
git commit -m "Rebuild and update system"
git diff
git push

echo "Rebuild and update completed and pushed to Github"
