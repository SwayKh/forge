#! /usr/bin/env bash

# Make a cool logo
print_logo() {
  cat <<'EOF'
  __
 / _| ___  _ __ __ _  ___
| |_ / _ \| '__/ _` |/ _ \
|  _| (_) | | | (_| |  __/
|_|  \___/|_|  \__, |\___|
               |___/
EOF
}

set -e
clear
print_logo

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

SERVICES() {
  if confirm "Do you want to enable systemd-services? (y/n): "; then
    ./services.sh
  else
    echo "Service enabling skipped."
  fi
}

AUR         # Install a AUR helper
CHAOTIC_AUR # Install chaotic aur
PACKAGES    # Install packages listed in programs.conf
TPM         # Install tpm for tmux
SERVICES    # Setup systemd services
DOTFILES    # Install and link dotfiles

echo "Setup complete! You may want to reboot your system."
