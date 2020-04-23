# ARCHISO
ping archlinux.org
timedatectl set-ntp true

fdisk /dev/sda
# particion MBR (DOS) 1) root (70G) 2) swap (512M) 3) home (resto)
lsblk -fm
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home
lsblk -fm

pacstrap /mnt base linux linux-firmware dosfstools exfat-utils e2fsprogs ntfs-3g nano man-db man-pages texinfo

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
# CHROOT MODE

passwd

pacman -S sudo base-devel
useradd -m -s /bin/bash cosmo
passwd cosmo
env EDITOR=nano visudo
# agregar la siguiente linea: cosmo ALL=(ALL) ALL

pacman -S openssh
systemctl enable sshd

ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
nano /etc/locale.gen
# desomentamos en_US.UTF-8 UTF-8 y es_ES.UTF-8 UTF-8
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf

echo "koi" > /etc/hostname
nano /etc/hosts
# agregar las siguientes lineas
# 127.0.0.1	localhost
# ::1		localhost
# 127.0.1.1	koi.home.lan	koi
pacman -S dhcpcd
systemctl enable dhcpcd

nano /etc/mkinitcpio.conf
# modificar la linea MODULES=() --> MODULES=(i915)
mkinitcpio -p linux

# (https://gist.github.com/imrvelj/c65cd5ca7f5505a65e59204f5a3f7a6d)
# solución para el error:
# Possibly missing firmware for module: aic94xx
# Possibly missing firmware for module: wd719x
su cosmo
cd
pacman -S git
git clone https://aur.archlinux.org/aic94xx-firmware.git
cd aic94xx-firmware
makepkg -sri
git clone https://aur.archlinux.org/wd719x-firmware.git
cd wd719x-firmware
makepkg -sri
exit
mkinitcpio -p linux

pacman -S grub intel-ucode
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg

exit
# BACK TO ARCHISO

sync
umount -R /mnt

reboot

# continua en koi-first-boot-installations



























