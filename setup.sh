#!/bin/bash
lsblk

disks=$(lsblk -o PATH,TYPE | grep disk | awk '{print $1}')

echo 'Select disk to install the system'

PS3="Disk number: "
disk_to_insall=""
select disk in $disks
do
  if [[ "${disks[@]}" =~ "$disk" ]]; then
    disk_to_insall=$disk
    echo 'System will be installed in '$disk_to_insall
    break
  else
    echo 'Incorrect number'
  fi
done

echo 'Erasing data on '$disk_to_insall
sfdisk --delete $disk_to_insall

lsblk $disk_to_insall


--------------------


echo '1.1.1'
(
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


echo '1.1.2'

mkfs.vfat /dev/sda1
mkfs.btrfs -f /dev/sda2


echo '1.2.1'
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI


echo '1.2.2 Установка основных пакетов'
pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware dosfstools btrfs-progs intel-ucode iucode-tool nano --noconfirm

echo '1.2.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Technomag31/my1/main/arch2.sh)"
