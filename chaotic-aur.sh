#!/usr/bin/env bash

set -e

newline() { echo ""; }

update_system() {
  sudo pacman -Syu --noconfirm
  echo "System updated successfully."
}

add_keys() {
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 3056513887B78AEB
}

install_chaotic() {
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
}

update_pacman_config() {
  if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo "#Chaotic-AUR" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null
  fi
}

check_chaotic_exists() {
  pacman -Qi chaotic-keyring &>/dev/null
  return $?
}

if check_chaotic_exists; then
  newline
  echo "Chaotic AUR is already installed,"
  echo "Updating system"
  update_system
else
  newline
  echo "Chaotic AUR is not installed. Installing Chaotic AUR..."
  newline
  add_keys
  install_chaotic
  update_pacman_config
  update_system
fi
