#!/usr/bin/env bash
# SOLUKOS_PERSIST etiketli bir bolum yoksa kullaniciyi bilgilendir.
# Bolum olusturulup yeniden baslatilinca bu bildirim bir daha cikmaz
# (kosul kendiliginden ortadan kalkiyor).
if ! blkid -L SOLUKOS_PERSIST >/dev/null 2>&1; then
    kdialog --title "SolukOS - Kalici Depolama" --msgbox \
        "Bu USB'de kalici depolama (SOLUKOS_PERSIST) henuz kurulu degil.\n\nKalici hale getirmek icin:\n1) GParted'i ac\n2) Bu USB'de bos alanda yeni bir bolum olustur\n3) Dosya sistemi: ext4, Etiket: SOLUKOS_PERSIST\n4) Yeniden baslat - degisiklikler artik kalici olacak." 2>/dev/null
fi
