#! /usr/bin/env bash

# Check dotfiles beings clones
# Check scripts being cloned
# Check if linksym is installed
# Check yay/paru is installed
#
# Make variable groups for differenct kinds of packages
# Make sure to install dependencies
# install them with yay/paru
#
# Make a cool logo
# Make helper functions for checking if package is installed
# Only works with dotfiles being cloned anyways.
#
# Make notes for TPM and other personally installed packages
#
# Window manager, it's components and dependencies
# Audio programs
# GUI programs
# AUR programs
# Dependencies
# Fonts
# Programming languages
# Setup Chaotic AUR
# Clone dotfiles
# Setup tpm
# Setup yay/paru install
# Start any services (like ly login manager/wallchange)
#
# Setup Paru/Yay and Chaotic AUR before installing the programs

clear
set -e

# Source the package list
if [ ! -f "programs.conf" ]; then
  echo "Error: programs.conf not found!"
  exit 1
fi
source programs.conf

source utils.sh

echo "Updating the system..."
sudo pacman -Syu --noconfirm

confirm() {
  local prompt="$1"
  echo -ne "$prompt (y/n): "
  read -r answer
  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  [[ "$answer" == "y" || "$answer" == "yes" ]]
}

AUR() {
  local helper=""
  echo -ne "Choose an AUR helper to use (paru/yay): "
  read -r helper
  ./aur-helper.sh "$helper"
}

CHAOTIC_AUR() {
  if confirm "Do you want to install Chaotic AUR? (y/n): "; then
    ./chaotic-aur.sh
  else
    echo "Chaotic AUR installation skipped."
  fi
}

TPM() {
  if confirm "Do you want to install TPM(tmux plugin manager)? (y/n): "; then
    ./tpm.sh
  else
    echo "TPM installation skipped."
  fi
}

DOTFILES() {
  if confirm "Do you want to clone dotfiles and install symlinks? (y/n): "; then
    ./dotfiles.sh
  else
    echo "dotfiles installation skipped."
  fi
}

PACKAGES() {
  # Install packages by category

  echo "Installing base system packages..."
  install_packages "${SYSTEM_PKGS[@]}"

  echo "Installing basic cli tools..."
  install_packages "${BASE_CLI_PKGS[@]}"

  echo "Installing extra useful cli tools..."
  install_packages "${EXTRA_CLI_PKGS[@]}"

  echo "Installing Base GUI packages..."
  install_packages "${BASE_GUI_PKGS[@]}"

  echo "Installing Extra GUI packages..."
  install_packages "${EXTRA_GUI_PKGS[@]}"

  echo "Installing packages for audio..."
  install_packages "${AUDIO_PKGS[@]}"

  echo "Installing nerd fonts..."
  install_packages "${FONTS[@]}"

  echo "Installing programming languages..."
  install_packages "${PROGRAMMING_LANGS[@]}"

  echo "Installing River window manager and its utilities..."
  install_packages "${WINDOW_MANAGER[@]}"

  echo "Installing dependency programs for script and other software..."
  install_packages "${DEPENDENCIES[@]}"

  echo "Installing packages for Xbox controller support..."
  install_packages "${CONTROLLER[@]}"
}

AUR         # Install a AUR helper
CHAOTIC_AUR # Install chaotic aur
PACKAGES    # Install packages listed in programs.conf
TPM         # Install tpm for tmux
DOTFILES    # Install and link dotfiles

echo "Setup complete! You may want to reboot your system."
