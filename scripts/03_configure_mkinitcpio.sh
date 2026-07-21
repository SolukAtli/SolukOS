#!/usr/bin/env bash
set -e
echo "[SolukOS] mkinitcpio ve depolama modülleri yapılandırılıyor..."
source ./config/solukos.conf

CHROOT_DIR="${WORK_DIR}/chroot"

# mkinitcpio.conf dosyasını güncelle
cat << 'MKEOF' > "${CHROOT_DIR}/etc/mkinitcpio.conf"
# SolukOS - Genişletilmiş Depolama ve USB Desteği
MODULES=(nvme ahci usb_storage uas xhci_pci xhci_hcd vfat ext4 squashfs overlay)
BINARIES=()
FILES=()
HOOKS=(base udev block filesystems keyboard fsck)
MKEOF

# Initramfs imajını chroot içinde yeniden oluştur
echo "[SolukOS] Initramfs imajı tüm sürücüler dahil edilerek derleniyor..."
arch-chroot "${CHROOT_DIR}" mkinitcpio -P
