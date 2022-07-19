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
  echo +100M # Last sector

  echo n # Add a new partition
  echo 2 # Partition number
  echo   # First sector (Accept default)
  echo +250M # Last sector

  echo n # Add a new partition
  echo 3 # Partition number
  echo   # First sector (Accept default)
  echo   # Last sector (Accept default: whole space)

  echo t # Change partition type
  echo 1 # Partition number
  echo 1 # EFI type

  echo t # Change partition type
  echo 2 # Partition number
  echo 20 # Linux filesystem type

  echo t # Change partition type
  echo 3 # Partition number
  echo 20 # Linux filesystem type

  echo w # Write changes
) | fdisk $disk_to_insall

lsblk $disk_to_insall

partitions=( $(lsblk $disk_to_insall -o PATH -n | tail -n +2) )

efi=${partitions[0]}
boot=${partitions[1]}
luks=${partitions[2]}

echo "EFI partition:" $efi
echo "Boot partition:" $boot
echo "LUKS partition:" $luks

cat /dev/zero > $efi
cat /dev/zero > $boot

echo "Formating partitions"
mkfs.vfat -F 32 $efi
mkfs.ext2 $boot

echo "Mounting partitions"
mount /dev/$luks mnt
mkdir -p /mnt/boot/efi
mount $efi /mnt/boot/efi

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

echo "Installing Arch"
    pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware \
    dosfstools btrfs-progs intel-ucode iucode-tool nano git iwd 
    #vim zsh 


echo "Generating FSTAB"
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Technomag31/my1/main/arch2.sh)"
