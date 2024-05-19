#!/system/bin/sh
export PATH="/system/bin"

mkdir -p /media/cdrom0 /mnt /proc /sys

mount -t devtmpfs udev /dev
mount -t sysfs sysfs /sys
mount -t proc proc /proc

mount -t iso9660 /dev/sr0 /media/cdrom0
mount -t squashfs -o loop /media/cdrom0/boot/root.sfs /mnt

sysctl -w kernel.printk="2 4 1 7"
# clear

sh

poweroff -f
