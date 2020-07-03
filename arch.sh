#!/bin/bash
dhcpcd
timedatectl set-ntp true

lsblk
echo "choose a disk to wipe"
read wipedisk

fdisk /dev/$wipedisk

echo -e "which type is your device?\n1.uefi 2.mbr or virtualbox"
read uefi


lsblk
echo "input boot disk"
read boot
echo "input root disk"
read root 
mkfs.ext4 /dev/$root
mount /dev/$root /mnt
if [ $uefi -eq 1 ];then
mkfs.fat -F32 /dev/$boot
mkdir -p /mnt/boot/efi
mount /dev/$boot /mnt/boot/efi
else
mkfs.ext4 /dev/$boot
mkdir -p /mnt/boot
mount /dev/$boot /mnt/boot
fi


sed -i "7i# 163\nServer = http://mirrors.163.com/archlinux/\$repo/os/\$arch\n## aliyun\nServer = http://mirrors.aliyun.com/archlinux/\$repo/os/\$arch\n# 清华大学\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch\n" /etc/pacman.d/mirrorlist
pacman -Syy

pacstrap /mnt base linux linux-firmware   base-devel  vim vi dhcpcd
genfstab -U /mnt >> /mnt/etc/fstab

cp archchroot.sh /mnt/root/
echo "please run cd ;chmod +x  archchroot.sh ;./archchroot.sh" 
arch-chroot /mnt
reboot
