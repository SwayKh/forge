#! /usr/bin/env bash

helper="$1"

# if no argument was provided to the script
if [[ -z "$helper" ]]; then
  echo -ne "Choose an AUR helper to install (paru/yay): "
  read -r helper
fi

# make input lowercase
helper=$(echo "$helper" | tr '[:upper:]' '[:lower:]')

if [[ "$helper" != "paru" && "$helper" != "yay" ]]; then
  echo "Invalid choice. Please select 'paru' or 'yay'."
  exit 1
fi

if command -v "$helper" >/dev/null 2>&1; then
  echo "$helper is already installed!"
  exit 0
fi

echo "Installing required dependecies."
sudo pacman -Sy --needed --noconfirm git base-devel

tmp_dir=$(mktemp -d)
echo "Cloning $helper into $tmp_dir."
git clone "https://aur.archlinux.org/${helper}.git" "$tmp_dir/$helper"

cd "$tmp_dir/$helper"
echo "Builing $helper"
makepkg -si --noconfirm

echo "DONE!"

rm -rf "$tmp_dir"

echo "Removed temporary files"
