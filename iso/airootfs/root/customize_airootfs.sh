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
