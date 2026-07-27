#!/usr/bin/env bash
set -e -u

# NOT: customize_airootfs.sh archiso'da deprecated isaretli ama surum 88'de
# hala calisiyor (sadece build loglarinda bir uyari basar). Ileride pacman
# hook'una tasinabilir.

# Taze bir pacstrap kurulumunda root hesabi kilitli gelir (sifre hash'i
# bos degil, "!"). Bu da boot sirasinda bir sey patlayip acil durum
# kabuguna (sulogin) dusuldugunde "root account is locked" hatasiyla hicbir
# mudahale sansi kalmamasina yol aciyordu. Debug icin bilinen bir sifre
# taniyoruz - ayni test kullanicisiyla (soluk/soluk) tutarli.
echo "root:soluk" | chpasswd

# Plymouth splash temasi (varsayilan "spinner" - sade, marka logosu
# eklenince degistirilebilir: plymouth-set-default-theme -l ile liste)
plymouth-set-default-theme spinner

# Saat dilimi + NTP: canli sistemde saat kaymasi Chromium/Google
# tarafinda "bot trafigi" gibi algilanip surekli captcha'ya yol
# acabiliyor. Saat dilimi etiketi (Europe/Istanbul) kozmetik - asil
# duzeltme systemd-timesyncd'nin agin gelmesiyle saati gercekten
# senkronize etmesi.
ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
systemctl enable systemd-timesyncd.service

# systemd-firstboot maskesi: BUILD ANINDA (bu script Linux CI runner'da
# chroot icinde calisiyor) sembolik link olusturuyoruz. Repoya committed
# statik bir /dev/null sembolik linki, gelistiricinin makinesindeki
# git/zip araci sembolik linki koruyamazsa (ozellikle Windows'ta git
# core.symlinks=false ise) duz metin dosyasina donusup
# "Service has no ExecStart=... Refusing" hatasina yol aciyordu - bunu
# gordunuz. Burada, hangi cihazdan/hangi arac ile push edilirse
# edilsin, build'i yapan Linux runner'da doğru sembolik link garanti
# olusuyor.
ln -sf /dev/null /etc/systemd/system/systemd-firstboot.service
