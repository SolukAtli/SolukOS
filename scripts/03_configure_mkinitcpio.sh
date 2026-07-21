#!/usr/bin/env bash
set -e
echo "[SolukOS] mkinitcpio ve depolama modülleri yapılandırılıyor..."
source ./config/solukos.conf

CHROOT_DIR="${WORK_DIR}/chroot"

# 1. Chroot içine archiso paketini garantiye almak için yüklüyoruz
echo "[SolukOS] Archiso paketi chroot ortamına kuruluyor..."
arch-chroot "${CHROOT_DIR}" pacman -Sy --noconfirm archiso

# 2. mkinitcpio.conf dosyasını güncelliyoruz
cat << 'MKEOF' > "${CHROOT_DIR}/etc/mkinitcpio.conf"
# SolukOS - Genişletilmiş Depolama ve Live Boot Desteği
MODULES=(nvme ahci usb_storage uas xhci_pci xhci_hcd vfat ext4 squashfs overlay)
BINARIES=()
FILES=()
HOOKS=(base udev archiso_kms archiso archiso_loop_mnt block filesystems keyboard)
MKEOF

# 3. Initramfs imajını archiso kancalarıyla birlikte oluşturuyoruz
echo "[SolukOS] Initramfs imajı derleniyor..."
arch-chroot "${CHROOT_DIR}" mkinitcpio -P
