#!/bin/bash

# Arch Linux Fast Install - Быстрая установка Arch Linux https://github.com/ordanax/arch
# Цель скрипта - быстрое развертывание системы с вашими персональными настройками (конфиг XFCE, темы, программы и т.д.).
# Автор скрипта Алексей Бойко https://vk.com/ordanax



# 'Скрипт сделан на основе чеклиста Бойко Алексея по Установке ArchLinux'
# 'Ссылка на чек лист есть в группе vk.com/arch4u'
echo 'I hope it will work'

# '2.3 Синхронизация системных часов'
echo '2.3'
timedatectl set-ntp true

# '2.4 создание разделов'
echo '2.4'
(
 echo d;
 echo;
 echo d;
 echo;
 echo d;
 echo;
 echo d;
 echo;
 
 echo g;

 echo n;
 echo;
 echo;
 echo +300M;
 echo t;
 echo 1;
  
 echo n;
 echo;
 echo;
 echo;
  
 echo w;
) | fdisk /dev/sda

echo 'Your disk layout'
fdisk -l


# '2.4.2 Форматирование дисков'
echo '2.4.2'
mkfs.vfat /dev/sda1
mkfs.btrfs -f /dev/sda2


# '2.4.3 Монтирование дисков'
echo '2.4.3'
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI


# '3.1 Выбор зеркал для загрузки.'
echo '3.1'
rm -rf /etc/pacman.d/mirrorlist
wget https://git.io/mirrorlist
mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

# '3.2 Установка основных пакетов'
echo '3.2'
pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware dosfstools btrfs-progs intel-ucode iucode-tool nano 

# '3.3 Настройка системы'
echo '3.3'
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/archuefi2.sh)"
