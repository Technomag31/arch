#!/bin/bash

echo 'xdg-user-dirs'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update
mkdir ~/AUR

echo 'wget & git'
sudo pacman -Syu
sudo pacman -S wget git --noconfirm

echo 'swapfile'
sudo touch swapfile
sudo chattr +C swapfile
sudo fallocate --length 2048MiB swapfile
sudo chown root swapfile
sudo chmod 600 swapfile
sudo mkswap	swapfile
sudo swapon swapfile
sudo '/home/technomag31/swapfile                                 none            swap    sw              0       0' >> /etc/fstab

echo 'programs'
sudo pacman -S telegram-desktop krita pulseaudio pavucontrol transmission-cli virtualbox teamviewer steam --noconfirm


cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git 
cd google-chrome 
makepkg -si --noconfirm
cd ~/AUR
sudo rm -r cd ~/AUR/google-chrome



cd

#echo 'Xfce settings'
#wget https://github.com/Technomag31/my1/raw/main/attach/config.tar.gz
#sudo rm -rf ~/.config/xfce4/*
#sudo tar -xzf config.tar.gz -C ~/

echo 'ArchLinux menu'
wget https://github.com/Technomag31/my1/raw/main/attach/arch_logo.png
sudo mv -f ~/downloads/arch_logo.png /usr/share/pixmaps/arch_logo.png

echo 'add core modules'
sed -i 's/MODULES=()/MODULES=(crc32c libcrc32 zlib_deflate btrfs nvidia nvidia_modset nvidia_uvm nvidia_drm)/g' /
sudo mkinitcpio -p linux-zen 

sudo pacman -Syu
# clear
rm -rf ~/downloads/

reboot
