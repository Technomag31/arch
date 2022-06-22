#!/bin/bash


echo '2.1.1'
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo technopc31 > /etc/hostname
echo -e "\n\n127.0.0.1  localhost\n::1        localhost\n127.0.0.1  technopc31.localdomain  technopc31" >> /etc/hosts

echo '2.1.2'
mkinitcpio -p linux-zen


echo '2.1.3'
(
 echo rfhffcz2009;
 echo rfhffcz2009;
) | passwd


echo '2.2.1'
pacman -S grub efibootmgr dhcpcd dhclient networkmanager --noconfirm 
grub-install /dev/sda

echo '2.2.2'
grub-mkconfig -o /boot/grub/grub.cfg


echo '2.3.1'
useradd -m -G wheel -s /bin/bash technomag31


echo '2.3.2'
(
 echo 123;
 echo 123;
) | passwd technomag31

echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo '2.4.1'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo '2.5.1'
pacman -S xorg-server xorg-drivers xorg-xinit

echo "2.5.2"
pacman -S xfce4 xfce4-goodies --noconfirm

echo '2.5.3'
pacman -S lxdm --noconfirm
systemctl enable lxdm

echo '2.5.4.1'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo '2.5.4.2'
systemctl enable NetworkManager

