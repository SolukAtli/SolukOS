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

**Faz 3 (bu sürüm):** `soluk` CLI artık ISO'nun içine gömülü — `soluk`
kullanıcısıyla girince kabuk zaten zsh, `soluk pkg install X` gerçek
`pacman` kullanıyor. Ayrıca boot sırasında bir sorun çıkarsa müdahale
edebilmek için: root hesabına bir şifre tanımlandı (**root / soluk**,
sadece debug amaçlı) ve systemd'nin yerleşik debug kabuğu (Ctrl+Alt+F9,
şifresiz) açık.

**Faz 5 (bu sürüm, henüz test edilmedi):** Kalıcılık desteği eklendi.
USB'de `SOLUKOS_PERSIST` etiketli bir ext4 bölüm varsa, sistem artık
tüm değişiklikleri (kurulan paketler, ayarlar, dosyalar) oraya yazıyor —
RAM'e değil. Bölümü oluşturmak için masaüstüne GParted eklendi.

**Önemli sınırlama:** Rufus'un DD Image mode'u USB'nin **tüm** disk
düzenini yeniden yazar. Yani ISO'yu bir dahaki sefere yeniden derleyip
aynı USB'ye yazınca, kalıcılık bölümü de silinir ve yeniden
oluşturulması gerekir. Sık ISO güncellemesi planlanıyorsa, kalıcılık
bölümünü ayrı bir ikinci USB'de tutmak daha az sürtünmeli olur
(`cow_label=SOLUKOS_PERSIST` hangi fiziksel USB'de olursa olsun o
etiketi arar, aynı USB olması şart değil).

## Şu an içinde ne var (Faz 3)

**Faz 0-2 (tamamlandı, USB'de doğrulandı):** derleme hattı, KDE Plasma 6
masaüstü, `soluk`/`soluk` kullanıcısı, Chromium, Soluk renk teması.

**Faz 3 (bu sürüm, henüz test edilmedi):** `soluk` CLI artık ISO'nun içinde
önceden kurulu geliyor. Giriş yapar yapmaz:

- `soluk` komutu doğrudan çalışır (Konsole'da `soluk help` dene)
- Kabuk zaten zsh (fzf/zoxide/bat/eza dahil, `soluk help` çıktısındaki
  kısayollar aktif)
- `soluk pkg install/remove/update` gerçek `pacman` kullanır
- Tema, banner, zshrc otomatik uygulanmış durumda

Bunu mümkün kılan mekanizma: CLI kod ağacı (`bin/`, `scripts/`, `plugins/`,
`packages/`, `config/`, ...) build sırasında GitHub Actions tarafından
`/opt/solukos`'a kopyalanıyor (repo'da statik bir kopya tutmuyoruz - tek
kaynak hep kod ağacının kökü, drift riski yok), sonra ilk açılışta yeni bir
systemd servisi (`solukos-cli-setup.service`) `soluk` komutunu
`~/.local/bin`'e, zshrc'yi `~/.zshrc`'ye kopyalayıp temayı uyguluyor.

**Bilinen sınırlama:** `/opt/solukos` root sahipliğinde salt-okunur - yani
canlı USB oturumunda `soluk update` (git pull) çalışmaz. Bu şu an için
sorun değil (zaten hiçbir şey kalıcı değil), ama Faz 5'te kalıcı USB/kurulum
gelince yeniden ele alınması gerekiyor.

## Bilinen sınırlama

Faz 3 sandbox'ta test edilemedi (mkarchiso çalıştırılamıyor burada).
Renk şemalarının formatı standart ve düşük riskli olsa da, gerçek USB testi
henüz yapılmadı — en kötü ihtimalle sadece varsayılan renklere döner, açılışı
engellemez.
