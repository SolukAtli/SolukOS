# SolukOS Linux — ISO Build (Faz 0)

Bu klasör, SolukOS'u gerçek bir Arch tabanlı, USB'den boot edilebilen bir
Linux dağıtımına çeviren `archiso` profilini içerir.

## Nasıl çalışıyor

Windows üzerinde yerel bir Arch/Linux kurulumuna gerek yok. ISO derlemesi
`.github/workflows/build-iso.yml` tarafından GitHub'ın sunucularında,
resmi `archlinux` Docker imajı içinde yapılır.

## Nasıl tetiklenir

**Manuel test (tag gerekmez):**
GitHub → repo → **Actions** sekmesi → **Build ISO** → **Run workflow**.

**Gerçek release:**
```
git tag iso-v0.1.0
git push origin iso-v0.1.0
```
Bu, ISO'yu derler ve otomatik olarak bir GitHub Release'e ekler.

## Sonucu nereden alırım

Workflow biterken (birkaç dakika sürer):
- Her çalıştırmada: Actions run sayfasının altında **Artifacts** bölümünde `solukos-iso` (14 gün saklanır)
- Tag ile tetiklenmişse: repo'nun **Releases** sekmesinde ayrıca .iso dosyası

USB'ye yazmak için Rufus / Ventoy / balenaEtcher kullanılabilir.

## Şu an içinde ne var (Faz 1)

**Faz 0 (tamamlandı, USB'de doğrulandı):** base sistem, NetworkManager,
derleme hattı (repo → GitHub Actions → bootlanabilir ISO) uçtan uca çalışıyor.

**Faz 1 (bu sürüm):** KDE Plasma 6 masaüstü eklendi. Giriş ekranı (SDDM)
karşılıyor:

- Kullanıcı adı: `soluk`
- Şifre: `soluk`

Bu geçici, test amaçlı bir hesap — Faz 5'te gerçek bir kurulum akışı
(Calamares) geldiğinde kullanıcı adı/şifre seçimi kurulum sırasında
sorulacak. `soluk` kullanıcısı `sudo` yetkisine sahip (wheel grubunda).

SDDM'nin giriş ekranındaki oturum seçici ikonundan "Plasma (X11)" veya
"Plasma (Wayland)" arasında seçim yapılabilir — hangisi donanımda daha
iyi çalışıyorsa onu kullan.

Soluk teması, `soluk` CLI'nin pacman'e taşınması, güvenlik araçları ve
kalıcı USB desteği henüz **eklenmedi** — sonraki fazlarda gelecek.

## Bilinen sınırlama

Bu profil sandbox ortamında (ağ erişimi yok) gerçek bir `mkarchiso`
çalıştırmasıyla test edilmedi. İlk çalıştırmada Actions log'unda bir hata
görülürse log'u buraya yapıştır, birlikte düzeltelim.
