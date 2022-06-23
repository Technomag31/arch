#!/bin/bash\

cd ~/AUR
git clone https://aur.archlinux.org/packages/nvidia-390xx-dkms
cd nvidia-390xx-utils 
makepkg -si --noconfirm
cd ~/AUR
sudo rm -r cd ~/AUR/nvidia-390xx-utils 


cd ~/AUR
git clone https://aur.archlinux.org/lib32-nvidia-390xx-utils.git
cd lib32-nvidia-390xx-utils  
makepkg -si --noconfirm
cd ~/AUR
sudo rm -r cd ~/AUR/lib32-nvidia-390xx-utils 

cd

sudo pacman -S bumblebee mesa xf86-video-intel lib32-virtualgl 


cd ~/AUR
git clone lib32-nvidia-340xx-utils
cd lib32-nvidia-390xx-utils  
makepkg -si --noconfirm
cd ~/AUR
sudo rm -r cd ~/AUR/lib32-nvidia-390xx-utils 


sudo gpasswd -a technomag31 bumblebee


sudo systemctl enable bumblebeed.service
