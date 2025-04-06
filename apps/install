#!/bin/bash

declare -a apt_pkgs

apt_pkgs=($(cat apt.txt))
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

clear

printf "\nFlatpak:-\n"
flatpak install --user -y --noninteractive flathub $(cat flatpak.txt)

exit 1

# Manual installs
## salut
git clone https://github.com/Wervice/salut
cd ./salut
g++ -o salutbin main.cpp -lfmt
sudo cp salutbin /usr/local/bin
cd ..

## Rust(Rustup)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## Eww
###git clone https://github.com/elkowar/eww
###cd eww
###cargo build --release --no-default-features --features=wayland
###cd target/release
###chmod +x ./eww
###sudo ln ./eww /usr/bin/
###eww daemon
###cd ../../../

## wluma
###git clone https://github.com/maximbaz/wluma.git
###cd wluma
###make build
###sudo make install
###cd ..
###rm -rf wluma

## Sway-Audio-Idle-Inhibit
###git clone https://github.com/ErikReider/SwayAudioIdleInhibit.git
###cd SwayAudioIdleInhibit
###meson build
###ninja -C build
###sudo meson install -C build
###cd ../

## mpvpaper
###git clone --single-branch https://github.com/GhostNaN/mpvpaper
#-- Build
###cd mpvpaper
###meson setup build --prefix=/usr/local
###ninja -C build
#-- Install
###ninja -C build install
###cd ..
###rm -rf mpvpaper

## Ghostty
git clone https://github.com/ghostty-org/ghostty
cd ghostty
zig build -Doptimize=ReleaseFast
sudo cp zig-out/bin/ghostty /usr/local/bin
cd ..
rm -rf ghostty

## ani-cli
git clone "https://github.com/pystardust/ani-cli.git"
sudo cp ani-cli/ani-cli /usr/local/bin
rm -rf ani-cli

## Zed
curl -f https://zed.dev/install.sh | bash

## Deno JS
curl -fsSL https://deno.land/install.sh | bash

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
