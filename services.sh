#! /usr/bin/env bash

newline() { echo ""; }

user=$(whoami)

SERVICES=(
  "NetworkManager"
  "bluetooth"
  "ly"
  "paccache"
  "reflector"
  "tlp"
  "sshd"
  "syncthing@${user}"
)

# Enable services
echo "Configuring systemd services..."
for service in "${SERVICES[@]}"; do
  if ! systemctl is-enabled "$service" &>/dev/null; then
    newline
    echo "Enabling $service..."
    sudo systemctl enable "$service"
  else
    echo "$service is already enabled"
  fi
done

newline
echo "Configuring user systemd services"
if ! systemctl --user is-enabled "wallchange.timer" &>/dev/null; then
  echo "Enabling wallchange.timer..."
  if [ -d "./wallchange" ]; then
    mkdir -p "$HOME/.config/systemd/user"
    cp ./wallchange/* "$HOME/.config/systemd/user/"
    systemctl --user enable wallchange.timer
  else
    echo "No wallchange directory found. Skipping user services setup."
  fi
else
  echo "wallchange.timer is already enabled"
fi
