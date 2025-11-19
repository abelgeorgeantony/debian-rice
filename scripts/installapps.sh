#!/bin/bash

declare -a apt_pkgs

apt_pkgs=($(cat ../apps/apt.txt))
outputmessage="APT:-\n"
printf $outputmessage
for pkg in ${apt_pkgs[@]};
do
    printf "\nTrying to install $pkg"
    sudo apt -y install "$pkg"
    pkgexistcheck=$((( dpkg -l "$pkg" 2>&1 ) | grep -E '^ii' > /dev/null ) && echo installed)
    if [ "${pkgexistcheck}" != "installed" ]; then
	    outputmessage="${outputmessage}\e[1;31m$pkg not installed\n\e[0m"
    else
	    outputmessage="${outputmessage}\e[1;32m$pkg is installed\n\e[0m"
    fi
    clear
    printf "${outputmessage}"
done

##clear

printf "\nFlatpak:-\n"
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub --user -y --noninteractive $(cat ../apps/flatpak.txt)

##clear

printf "\nInstalling NB note taker:-\n"
sudo npm install -g nb.sh
sudo nb env install

exit 1

# Manual installs
## lock.sh - Lock a terminal, to use with tty.
git clone https://github.com/ishbguy/lock.sh.git
sudo cp ./lock.sh/bin/lock.sh /usr/bin/lock.sh

## menu.sh - A terminal menu.
wget https://github.com/iandennismiller/menu.sh/raw/refs/heads/main/menu.sh
install -C -v ./menu.sh ~/.local/bin/menu.sh

## salut - A terminal greeter.
git clone https://github.com/Wervice/salut
cd ./salut
g++ -o salutbin main.cpp -lfmt
sudo cp salutbin /usr/local/bin
cd ..

## Rust(Rustup)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## Ghostty
git clone https://github.com/ghostty-org/ghostty
cd ghostty
zig build -Doptimize=ReleaseFast
sudo cp zig-out/bin/ghostty /usr/local/bin
cd ..
rm -rf ghostty

## Deno JS
curl -fsSL https://deno.land/install.sh | bash

## Ollama
curl -fsSL https://ollama.com/install.sh | sh

## scrcpy
git clone https://github.com/Genymobile/scrcpy
cd scrcpy
./install_release.sh
cd ..
rm -rf scrcpy

exit 1


#Apps to download from other source:
##	obs studio
##	virtualbox
##	TLauncher Minecraft
