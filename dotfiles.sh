#! /usr/bin/env bash

url="https://github.com/SwayKh/dotfiles"
repo_dir="dotfiles"

is_linksym_installed() {
  pacman -Qi "linksym" &>/dev/null
}

if ! is_linksym_installed; then
  echo "Please install linksym to create symlinks from dotfiles directory"
  exit 1
fi

cd "$HOME"

# Check if the repository already exists
if [ -d "$repo_dir" ]; then
  echo "Repository '$repo_dir' already exists. Skipping clone"
  exit 1
fi

# Check if the clone was successful
if git clone --recurse-submodules "$url"; then
  cd "$repo_dir"
  linksym update
  linksym source
else
  echo "Failed to clone the repository."
  exit 1
fi
