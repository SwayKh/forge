#! /usr/bin/env bash

set -e

if ! pacman -Q tmux &>/dev/null; then
  echo "tmux is not installed."
  exit 1
fi

tpm_dir="$HOME/.local/share/tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$tpm_dir" ]; then
  echo "TPM is already installed in $tpm_dir"
else
  echo "Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm $tpm_dir
fi

echo "TPM installed successfully!"
