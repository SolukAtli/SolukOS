#!/usr/bin/env bash
set -e
echo "[SolukOS] mkinitcpio ve depolama modülleri yapılandırılıyor..."
source ./config/solukos.conf

CHROOT_DIR="${WORK_DIR}/chroot"

# mkinitcpio.conf dosyasını hem depolama modülleri hem de Live ISO kancalarıyla güncelle
cat << 'MKEOF' > "${CHROOT_DIR}/etc/mkinitcpio.conf"
# SolukOS - Genişletilmiş Depolama ve Live Boot Desteği
MODULES=(nvme ahci usb_storage uas xhci_pci xhci_hcd vfat ext4 squashfs overlay)
BINARIES=()
FILES=()
HOOKS=(base udev archiso_kms archiso archiso_loop_mnt block filesystems keyboard)
MKEOF

# Initramfs imajını chroot içinde yeniden oluştur
echo "[SolukOS] Initramfs imajı derleniyor..."
arch-chroot "${CHROOT_DIR}" mkinitcpio -P
