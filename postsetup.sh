#!/bin/bash

ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime 
hwclock --systohc

systemctl enable iwd


echo technopc31 > /etc/hostname

echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf

locale-gen

echo "Root password"
passwd

echo "User password"
useradd -m -G wheel -s /bin/bash technomag31
passwd technomag31

hooks="HOOKS=(base udev autodetect modconf block keymap encrypt lvm2 resume filesystems keyboard fsck)"
sed -i "s/HOOKS=.*/$hooks/" /etc/mkinitcpio.conf

modules="MODULES=(i915 crc32c libcrc32 zlib_deflate btrfs)"
sed -i "s/MODULES=.*/$modules/" /etc/mkinitcpio.conf

mkinitcpio -p linux-zen

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux

grub='GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=\/dev\/mapper\/Arch-swap"'
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/$grub/" /etc/default/grub

grub2='GRUB_CMDLINE_LINUX="i915.enable_guc=2"'
sed -i "s/GRUB_CMDLINE_LINUX=.*/$grub2/" /etc/default/grub

mkdir /etc/modprobe.d/
echo "options i915 enable_guc=2" >> /etc/modprobe.d/i915.conf

home="/home/technomag31"

pacman -S --noconfirm \
    xorg-server xorg-xinit xorg-xbacklight xorg-xrandr xorg-xinput \
#    vlc krita telegram-desktop \
    alsa-utils pulseaudio pavucontrol pulseaudio-alsa pulseaudio-bluetooth bluez-utils \
    intel-ucode intel-ucode git p7zip grub xorg-xmodmap
    
grub-mkconfig -o /boot/grub/grub.cfg

git clone https://github.com/technomag31/dotfiles.git $home/.dotfiles

ln -s $home/.dotfiles/.Xmodmap $home/.Xmodmap
rm $home/.bashrc
ln -s $home/.dotfiles/.bashrc $home/.bashrc
ln -s $home/.dotfiles/.gitconfig  $home/.gitconfig 

xmodmap $home/.Xmodmap


mkdir /etc/iwd
touch /etc/iwd/main.conf
echo "[General]" >> /etc/iwd/main.conf
echo "EnableNetworkConfiguration=true" >> /etc/iwd/main.conf

pulseaudio -D
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

git clone https://aur.archlinux.org/yay.git $home/yay
chown -R technomag31 $home
cd $home/yay
sudo -u technomag31 makepkg -si
cd
rm -rf $home/yay
sudo -u technomag31 yay -S  google-chrome
chattr +i /etc/resolv.conf
systemctl enable bluetooth.service

pacman -Rscn xf86-video-intel
