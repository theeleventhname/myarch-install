#!/bin/bash
dhcpcd
timedatectl set-ntp true

lsblk
echo "choose a disk to wipe"
read wipedisk

fdisk /dev/$wipedisk

lsblk
echo "input boot disk"
read boot
echo "input root disk"
read root 
mkfs.fat -F32 /dev/$boot
mkfs.ext4 /dev/$root

mount $root /mnt
mkdir -p /mnt/boot/efi
mount $boot /mnt/boot/efi

echo "Server = http://mirrors.163.com/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
pacman -Syy

pacstrap /mnt base linux linux-firmware   base-devel  vim vi dhcpcd
genfstab -U /mnt >> /mnt/etc/fstab

cp archchroot.sh /mnt/root/
echo "please run chmod +x  archchroot.sh ;./archchroot.sh" 
arch-chroot /mnt
