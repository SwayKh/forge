# Forge

My Arch Linux Post-Install setup script. It automates the package installations
and other manual parts of my setup.

## Features
This scripts takes care of the following:
1. Update the system
2. Install AUR helper of choice (yay/paru)
3. Setup chaotic-aur on the system
4. Handle package installation in categories from [programs.conf](./programs.conf) (edit it as your
   needs)
5. Installs TPM for tmux
6. Auto enables basic systemd services
7. Clones and links my [dotfiles](https://github.com/SwayKh/dotfiles), using [linksym](https://github.com/SwayKh/linksym)
8. Adds a user systemd timer to change wallpaper and colors on the system
   using [hellwal](https://github.com/danihek/hellwal) and  [swww](https://github.com/LGFae/swww)

## Installation

1. Clone this repository
```sh
git clone https://github.com/SwayKh/forge
```
2. Run the Setup script
```sh
./setup.sh
```

3. Follow the prompts and select the parts of the script you want to run.
4. Reboot your system after the script is done.
