#! /usr/bin/env bash

newline() { echo ""; }

SERVICES=(
  "NetworkManager"
  "bluetooth"
  "ly"
  "paccache"
  "reflector"
)

# Enable services
echo "Configuring systemd services..."
for service in "${SERVICES[@]}"; do
  if ! systemctl is-enabled "$service" &>/dev/null; then
    newline
    echo "Enabling $service..."
    sudo systemctl enable "$service"
  else
    newline
    echo "$service is already enabled"
  fi
done

echo "Configuring user systemd services"
if ! systemctl --user is-enabled "wallchange.timer" &>/dev/null; then
  newline
  echo "Enabling wallchange.timer..."
  if [ -d "./wallchange" ]; then
    mkdir -p "$HOME/.config/systemd/user"
    cp ./wallchange/* "$HOME/.config/systemd/user/"
    systemctl --user enable wallchange.timer
  else
    newline
    echo "No wallchange directory found. Skipping user services setup."
  fi
else
  newline
  echo "wallchange.timer is already enabled"
fi
