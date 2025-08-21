#!/bin/bash

if [ "$EUID" -eq 0 ]
then
        echo -e "Do not run the script as root!\nScript stopped!"
        exit
fi

HelpText="This is the CONFIGuration MANager script of my Debian rice!\n\nThere are 2 modes for this script, update mode and save mode.\nIn update mode the script fetches the custom configs from this repository and updates it for the specified software.\nIn save mode the script fetches the currently applied configuration and saves it in the local copy of this repository.\n"

# Functions that add the custom configs
customconfigs=~/workspace/side/debianrice/configs
### bash
UpdateTerminal()
{
	cp -r $customconfigs/bash/. ~/
	cp -r $customconfigs/menu.sh/. ~/.local/bin/
	#source ~/.bashrc  #Need to make this work!!
	#bind -f ~/.inputrc  #Need to make this work!!
	echo "Terminal configs updated!"
}
SaveTerminal()
{
  cp -r ~/.bashrc $customconfigs/bash/
  cp -r ~/.inputrc $customconfigs/bash/
  cp -r ~/.local/bin/root.menu.yaml $customconfigs/menu.sh/
  echo "Terminal configs updated!"
}
### nvim
UpdateNvim()
{
	mkdir -p ~/.config/nvim
	cp -r $customconfigs/nvim/. ~/.config/nvim/
	echo "Nvim config updated!"
}
SaveNvim()
{
  cp -r ~/.config/nvim/. $customconfigs/nvim/
  echo "Nvim config saved!"
}
### gnome extensions
UpdateGExtensions()
{
  dconf load /org/gnome/shell/extensions/ < $customconfigs/gnome_extensions/extensions.conf
  echo "Gnome Extensions config updated!"
}
SaveGExtensions()
{
  dconf dump /org/gnome/shell/extensions/ > $customconfigs/gnome_extensions/extensions.conf
  echo "Gnome Extensions config saved!"
}

if [ "$1" == "--update-all" ]; then
	UpdateTerminal
	UpdateNvim
  UpdateGExtensions
elif [ "$1" == "--update" ]; then
	"Update"$2
elif [ "$1" == "--save-all" ]; then
  SaveTerminal
  SaveNvim
  SaveGExtensions
elif [ "$1" == "--save" ]; then
  "Save"$2
else
  echo -e $HelpText
fi
