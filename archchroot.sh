#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

echo -e "en_US.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8\nzh_CN.GBK GBK" >> /etc/locale.gen
locale-gen 
echo "LANG=zh_CN.UTF-8" > /etc/locale.conf

echo "archlinux" > /etc/hostname
echo -e "127.0.0.1   localhost\n::1              localhost\n127.0.1.1 archlinux.localdomain archlinux" > /etc/hosts
passwd

echo -e "which type is your cpu?\n1.intel 2.amd"
read cpu
if [ $cpu -eq 2 ];then
pacman -S  amd-ucode
else
pacman -S intel-ucode xf86-video-intel mesa
fi
pacman -S os-prober grub efibootmgr

echo -e "which type is your boot?\n1.uefi or virtualbox 2.mbr "
read uefi
if [ $uefi -eq 1 ];then
grub-install --target=x86_64-efi  --efi-directory=/boot/efi --bootloader-id=Archlinux  --recheck
else
lsblk
echo "input boot disk"
read mbr
grub-install --target=i386-pc /dev/$mbr
fi
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S iw wpa_supplicant dialog  netctl
systemctl enable dhcpcd

echo "input your account name:"
read user
useradd -m -g users -s /bin/bash $user
passwd $user
echo -e "$user ALL=（ALL）ALL" >> /etc/sudoers

pacman -S alsa-utils pulseaudio-alsa xorg 
echo -e "if your device is laptap with touch pannel?\n1.yes 2.no"
read touch
if [ $touch -eq 1 ];then
pacman -S xf86-input-synaptics
else
echo "nothing to do"
fi

pacman -S ttf-dejavu wqy-microhei wqy-zenhei plasma kde-applications ntfs-3g sddm sddm-kcm networkmanager netctl xdg-user-dirs unzip unrar neofetch
pacman -Rsn blinken bomber bovo granatier kajongg kanagram kapman katomic kblackbox kblocks kbounce kbreakout kdiamond kfourinline kgoldrunner khangman kigo killbots kiriki kjumpingcube klickety kmahjongg kmines knetwalk knights kolf kollision klines konquest kpatience kreversi ksirk ksnakeduel kspaceduel ksquares ksudoku kubrick lskat knavalbattle palapeli picmi ktuberling kshisen akregator kbackup kgpg kopete artikulate dragon  juk k3b kmix cervisia ktnef umbrello kteatime kig ktouch kturtle kmplot kalgebra kalzium kbruch marble kgeography klettres kwordquiz minuet parley step rocs kleopatra konqueror kdepim-addons
systemctl enable NetworkManager sddm dhcpcd 
sddm --example-config > /etc/sddm.conf

echo -e "if your device have bluetooth?\n1.yes 2.no"
read bluetooth
if [ $bluetooth -eq 1 ];then
pacman -S bluez bluez-utils pulseaudio-bluetooth
systemctl enable bluetooth
echo -e "load-module module-bluetooth-policy\nload-module module-bluetooth-discover" >> /etc/pulse/system.pa 
else
echo "nothing to do"
fi

echo "please run xdg-user-dirs-update --force after login as local user" |tee /home/$user/notice.txt
exit
