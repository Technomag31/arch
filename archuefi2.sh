#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
hwclock --systohc

read -p "Pc name: " hostname
read -p "user name: " username

echo $hostname > /etc/hostname


# 'Создадим загрузочный RAM диск'
mkinitcpio -p linux-zen

# '3.5 Устанавливаем загрузчик'
echo '3.5'
pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install /dev/sda

# 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

# 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

# 'Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username

# 'Создаем root пароль'
passwd 

# 'Устанавливаем пароль пользователя'
passwd $username

# 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

# 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

pacman -S xorg-server xorg-drivers xorg-xinit

# "Ставим XFCE"
pacman -S xfce4 xfce4-goodies --noconfirm

#'Cтавим DM'
pacman -S lxdm --noconfirm
systemctl enable lxdm

# 'Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu --noconfirm 

# 'Ставим сеть'
pacman -S networkmanager network-manager-applet ppp --noconfirm

# 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo 'type "reboot"'
# 'Если хотите подключить AUR, установить мои конфиги XFCE, тогда после перезагрзки и входа в систему, установите wget (sudo pacman -S wget) и выполните команду:'
# 'wget git.io/archuefi3.sh && sh archuefi3.sh'
exit
