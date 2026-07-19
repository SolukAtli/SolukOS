#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="solukos"
iso_label="SOLUKOS_$(date +%Y%m)"
iso_publisher="SolukOS <https://github.com/SolukAtli/SolukOS>"
iso_application="SolukOS Linux Live/Rescue USB"
iso_version="$(date +%Y.%m.%d)"
install_dir="solukos"
buildmodes=('iso')
bootmodes=(
    'bios.syslinux'
    'uefi.grub'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19')
file_permissions=(
    ["/etc/shadow"]="0:0:400"
    ["/root"]="0:0:750"
    ["/etc/sudoers.d/wheel"]="0:0:440"
    ["/opt/solukos/bin/soluk"]="0:0:755"
    ["/opt/solukos/install.sh"]="0:0:755"
)
