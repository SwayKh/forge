#! /usr/bin/env bash

newline() { echo ""; }

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
echo "--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"

# Source the package list
if [ ! -f "programs.conf" ]; then
  newline
  echo "Error: programs.conf not found!"
  exit 1
fi

source programs.conf

source utils.sh

newline
echo "Updating the system..."
sudo pacman -Syu --noconfirm

confirm() {
  echo "--------------------------------------------------------------------------------"
  local prompt="$1"
  echo -ne "$prompt"
  read -r answer
  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  [[ "$answer" == "y" || "$answer" == "yes" ]]
}

AUR() {
  ./aur-helper.sh
}

CHAOTIC_AUR() {
  if confirm "Do you want to install Chaotic AUR? (y/n): "; then
    ./chaotic-aur.sh
  else
    newline
    echo "Chaotic AUR installation skipped."
  fi
}

TPM() {
  if confirm "Do you want to install TPM(tmux plugin manager)? (y/n): "; then
    ./tpm.sh
  else
    newline
    echo "TPM installation skipped."
  fi
}

DOTFILES() {
  if confirm "Do you want to clone dotfiles and install symlinks? (y/n): "; then
    ./dotfiles.sh
  else
    newline
    echo "dotfiles installation skipped."
  fi
}

PACKAGES() {
  # Install packages by category
  if confirm "Do you want to install package from programs.conf? (y/n): "; then

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

    echo "Installing Window manager/Compositor and its utilities..."
    install_packages "${WINDOW_MANAGER[@]}"

    echo "Installing dependency programs for script and other software..."
    install_packages "${DEPENDENCIES[@]}"

    echo "Installing packages for Xbox controller support..."
    install_packages "${CONTROLLER[@]}"

  else
    echo "Service enabling skipped."
  fi
}

SERVICES() {
  if confirm "Do you want to enable systemd-services? (y/n): "; then
    ./services.sh
  else
    echo "Service enabling skipped."
  fi
}

AUR         # Install a AUR helper

check_installed_helper # Set the helper variable in Utils.sh script, after installing Paru/Yay

CHAOTIC_AUR # Install chaotic aur
PACKAGES    # Install packages listed in programs.conf
TPM         # Install tpm for tmux
SERVICES    # Setup systemd services
DOTFILES    # Install and link dotfiles

echo "--------------------------------------------------------------------------------"
newline
echo "Setup complete! You may want to reboot your system."
