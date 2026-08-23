#!/usr/bin/env bash
set -e -u

echo "root:soluk" | chpasswd

ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
systemctl enable systemd-timesyncd.service

ln -sf /dev/null /etc/systemd/system/systemd-firstboot.service

# Tema sistemi: aktif temayi gosteren symlink. Ayni sebepten (Windows'ta
# git symlink'leri koruyamayabiliyor) bunu repo'da committed bir dosya
# olarak degil, burada, Linux build konteynerinde olusturuyoruz.
ln -sfn themes/solukos /etc/skel/.config/soluk/current-theme

# rmpc/mpd - kullanici mpd servisini etkinlestir + gerekli dizinler
mkdir -p /etc/skel/Music
mkdir -p /etc/skel/Videos
mkdir -p /etc/skel/.config/mpd/playlists
mkdir -p /etc/skel/.config/systemd/user/default.target.wants
ln -sf /usr/lib/systemd/user/mpd.service /etc/skel/.config/systemd/user/default.target.wants/mpd.service

# yazi temasi - paylasilan tema klasorunden sembolik baglanti
mkdir -p /etc/skel/.config/yazi
ln -sf ../soluk/themes/solukos/yazi-theme.toml /etc/skel/.config/yazi/theme.toml

# bluetooth + guc profili sistem servisleri
mkdir -p /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/bluetooth.service /etc/systemd/system/multi-user.target.wants/bluetooth.service
ln -sf /usr/lib/systemd/system/power-profiles-daemon.service /etc/systemd/system/multi-user.target.wants/power-profiles-daemon.service
