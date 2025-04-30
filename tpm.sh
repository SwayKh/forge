#! /usr/bin/env bash

set -e

newline() { echo ""; }

if ! pacman -Q tmux &>/dev/null; then
  newline
  echo "tmux is not installed."
  exit 1
fi

tpm_dir="$HOME/.local/share/tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$tpm_dir" ]; then
  newline
  echo "TPM is already installed in $tpm_dir"
else
  newline
  echo "Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm $tpm_dir
fi

newline
echo "TPM installed successfully!"
