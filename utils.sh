#! /usr/bin/env bash

# Credit to typecraft-dev/crucible for a lot of parts of this script

# Function to check if a package is installed
is_installed() {
  pacman -Qi "$1" &>/dev/null
}

check_installed_helper() {
  if pacman -Qi yay &>/dev/null; then
    helper="yay"
  elif pacman -Qi paru &>/dev/null; then
    helper="paru"
  else
    echo "Yay or Paru are not installed!"
    exit 1
  fi
}
check_installed_helper

install_packages() {
  local packages=("$@")
  local to_install=()

  if [ -z "$helper" ]; then
    echo "Error: AUR helper not defined!"
    exit 1
  fi

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing: ${to_install[*]}"
    "$helper" -S --noconfirm "${to_install[@]}"
  fi
}
