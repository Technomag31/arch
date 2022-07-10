# /bin/bash
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

echo 'Creating partitions'
(
  echo g # Create a new empty GPT partition table

  echo n # Add a new partition
  echo 1 # Partition number
  echo   # First sector (Accept default)
  ec  ho +31M # Last sector (Accept default: whole space)

  echo n # Add a new partition
  echo 2 # Partition number
  echo   # First sector (Accept default)
  echo +100M # Last sector

  echo n # Add a new partition
  echo 3 # Partition number
  echo   # First sector (Accept default)
  echo +250M # Last sector

  echo n # Add a new partition
  echo 4 # Partition number
  echo   # First sector (Accept default)
  echo   # Last sector (Accept default: whole space)
  
  echo t # Change partition type
  echo 1 # Partition number
  echo 4 # BIOS boot type

  echo t # Change partition type
  echo 2 # Partition number
  echo 1 # EFI type

  echo t # Change partition type
  echo 3 # Partition number
  echo 20 # Linux filesystem type
  
  echo t # Change partition type
  echo 4 # Partition number
  echo 20 # Linux filesystem type

  echo w # Write changes
) | fdisk $disk_to_insall

lsblk $disk_to_insall

partitions=( $(lsblk $disk_to_insall -o PATH -n | tail -n +2) )

efi=${partitions[1]}
boot=${partitions[2]}
luks=${partitions[3]}

echo "EFI partition:" $efi
echo "Boot partition:" $boot
echo "LUKS partition:" $luks

cat /dev/zero > $efi
cat /dev/zero > $boot

echo "Formating partitions"
mkfs.vfat -F 32 $efi
mkfs.ext2 $boot

device_alias='encrypted'
lv_name='Arch'
swap_name='swap'
root_name='root'

echo "Creating encrypted drive"
cryptsetup -c aes-xts-plain64 -h sha512 -s 512 -q --use-random luksFormat $luks

echo "Entering encrypted drive"
cryptsetup luksOpen $luks $device_alias

pvcreate /dev/mapper/$device_alias
vgcreate $lv_name /dev/mapper/$device_alias

memory_size_gb=$(free -g | grep Mem | awk '{print $2}')
echo "Memory size: " $memory_size_gb

echo "Creating encrypted partitions"
lvcreate -L +$memory_size_gb"G" $lv_name -n $swap_name
lvcreate -l +100%FREE $lv_name -n $root_name

lsblk $disk_to_insall

echo "Formating encrypted partitions"
mkswap /dev/mapper/$lv_name-$swap_name
mkfs.ext4 /dev/mapper/$lv_name-$root_name

echo "Mounting partitions"
mount /dev/mapper/$lv_name-$root_name /mnt
swapon /dev/mapper/$lv_name-$swap_name
mkdir /mnt/boot
mount $boot /mnt/boot
mkdir /mnt/boot/efi
mount $efi /mnt/boot/efi

echo "Installing Arch"
pacstrap /mnt base base-devel grub efibootmgr linux linux-headers iwd vim \
  lvm2 linux-firmware git zsh
echo "Generating FSTAB"
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash -c "curl -L -o /home/setup.sh https://git.io/JtaY5 && chmod +x /home/setup.sh && /home/setup.sh"













------------------


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
