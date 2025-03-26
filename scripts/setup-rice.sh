#!/bin/bash

if [ "$EUID" -eq 0 ]
then
	echo -e "Do not run the script as root!\nEnter user password only when prompted!\nSetup aborted!"
	exit
fi

# Creating the workspace directories
mkdir -pv ~/workspace/main/
mkdir ~/workspace/side/

# Moving the debianrice directory to side projects directory
mv ../../debianrice ~/workspace/side/

# Adding custom fonts(System-Wide)
sudo mkdir -pv /usr/local/share/fonts/
sudo cp -r ../fonts/* /usr/local/share/fonts/

# Making the utitlity scripts globally accessible(using hard links)
sudo ln ./utilities/keyboard-backlight /usr/bin/
sudo ln ./utilities/fortuneteller.sh /usr/bin/
sudo ln ./utilities/configman /usr/bin/

# Adding 3rd parties to APT
sudo mkdir -pv /etc/apt/keyrings
### Adding Charm Bracelet
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

sudo apt update

# Running the script that downloads the apps
sudo ../apps_lists/installapps.sh

# Adding the custom configs
configman --update-all

# Disabling gdm from autostarting
sudo systemctl set-default multi-user.target
