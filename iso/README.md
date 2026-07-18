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

## Şu an içinde ne var (Faz 0)

Sadece iskelet: base sistem, NetworkManager, root autologin, temel araçlar.
KDE Plasma, Soluk teması, `soluk` CLI'nin pacman'e taşınması ve kalıcı USB
desteği henüz **eklenmedi** — bunlar sonraki fazlarda gelecek. Bu ilk sürümün
tek amacı: derleme hattının (repo → GitHub Actions → bootlanabilir ISO)
uçtan uca çalıştığını kanıtlamak.

## Bilinen sınırlama

Bu profil sandbox ortamında (ağ erişimi yok) gerçek bir `mkarchiso`
çalıştırmasıyla test edilmedi. İlk çalıştırmada Actions log'unda bir hata
görülürse log'u buraya yapıştır, birlikte düzeltelim.
