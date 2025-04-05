#!/bin/bash

if [ "$EUID" -eq 0 ]
then
        echo -e "Do not run the script as root!\nScript stopped!"
        exit
fi

# Functions that add the custom configs
customconfigs=~/workspace/side/debianrice/configs
### bash
AddBash()
{
	cp -r $customconfigs/bash/. ~/
	#source ~/.bashrc  #Need to make this work!!
	echo "Bash config updated!"
}
### nvim
AddNvim()
{
	mkdir -p ~/.config/nvim
	cp -r $customconfigs/nvim/. ~/.config/nvim/
	echo "Nvim config updated!"
}

if [ "$1" == "--update-all" ]; then
	AddBash
	AddNvim
elif [ "$1" == "--update" ]; then
	"Add"$2
fi
