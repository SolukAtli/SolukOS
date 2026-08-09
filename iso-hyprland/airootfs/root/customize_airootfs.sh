#!/usr/bin/env bash
set -e -u

echo "root:soluk" | chpasswd

ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
systemctl enable systemd-timesyncd.service

ln -sf /dev/null /etc/systemd/system/systemd-firstboot.service
