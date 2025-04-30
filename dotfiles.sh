#! /usr/bin/env bash

newline() { echo ""; }

url="https://github.com/SwayKh/dotfiles"
repo_dir="dotfiles"

if ! pacman -Qi "linksym" &>/dev/null; then
  newline
  echo "Please install linksym to create symlinks from dotfiles directory"
  exit 1
fi

cd "$HOME"

# Check if the repository already exists
if [ -d "$repo_dir" ]; then
  echo "Repository '$repo_dir' already exists. Skipping clone"
  exit 0
fi

# Check if the clone was successful
if git clone --recurse-submodules "$url"; then
  cd "$repo_dir"
  linksym update
  linksym source
else
  newline
  echo "Failed to clone the repository."
  exit 1
fi
