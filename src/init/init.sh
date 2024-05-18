#!/system/bin/sh
export PATH="/system/bin"

mkdir /dev /proc /sys

mount -t devtmpfs udev /dev
mount -t sysfs sysfs /sys
mount -t proc proc /proc

sysctl -w kernel.printk="2 4 1 7"
clear

sh

poweroff -f
