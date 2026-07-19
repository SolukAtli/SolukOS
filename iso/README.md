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

## Şu an içinde ne var (Faz 2)

**Faz 0 (tamamlandı, USB'de doğrulandı):** derleme hattı uçtan uca çalışıyor.

**Faz 1 (tamamlandı, USB'de doğrulandı):** KDE Plasma 6 masaüstü, giriş
ekranı, `soluk`/`soluk` kullanıcısı, Chromium tarayıcı.

**Faz 2 (bu sürüm, henüz test edilmedi):** Soluk kimliği — terminal
(Konsole) ve KDE uygulama renk şeması artık `scripts/theme.sh`'deki
`soluk` paletiyle birebir aynı (`#1c1f24` arka plan, gri-mavi-altın
tonları). `soluk` kullanıcısı ile giriş yapınca hem masaüstü uygulamaları
hem Konsole otomatik olarak bu renklerle açılır.

**Bilinçli olarak ertelenenler:** SDDM giriş ekranı teması, Plymouth açılış
ekranı ve duvar kağıdı bu sürüme eklenmedi. Sebep: gerçek "S + sis" logosu
henüz tasarlanmadı, ve bu ikisi (özellikle SDDM teması) yanlış yazılırsa
grafik girişin hiç açılmaması gibi ciddi bir bozulma riski taşıyor — logo
hazır olup gerçekten USB'de test edebildiğimizde ele alınacak.

## Bilinen sınırlama

Faz 2 sandbox'ta test edilemedi (mkarchiso çalıştırılamıyor burada).
Renk şemalarının formatı standart ve düşük riskli olsa da, gerçek USB testi
henüz yapılmadı — en kötü ihtimalle sadece varsayılan renklere döner, açılışı
engellemez.
