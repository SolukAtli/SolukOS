# SolukOS Kurulum Rehberi

> Not: Bu rehber, `soluk` CLI'nin gerçek bir Arch Linux sistemi (SolukOS
> Linux ISO'su ya da herhangi bir Arch/Arch-tabanli dagitim) uzerine
> kurulumunu anlatir. Eskiden Termux (Android) uzerinde de calisiyordu,
> ama Faz 3'te `pkg` yerine `pacman` kullanacak sekilde tasindigi icin
> Termux'ta artik calismiyor. USB'den bootlanabilir SolukOS Linux ISO'sunu
> derlemek icin [`iso/README.md`](../iso/README.md) dosyasina bakin.

## Gereksinimler

- Arch Linux ya da Arch-tabanli bir sistem (`pacman` mevcut olmali)
- `git` kurulu olmali (kurulu degilse: `sudo pacman -S git`)
- `sudo` yetkisi olan bir kullanici

## Kurulum

1. `git`in kurulu oldugundan emin olun:

   ```
   sudo pacman -S git
   ```

2. Repoyu klonlayin:

   ```
   git clone https://github.com/SolukAtli/SolukOS.git
   cd SolukOS
   ```

3. Kurulum betigini calistirilabilir yapip baslatin:

   ```
   chmod +x install.sh
   ./install.sh
   ```

4. Menuden **[1] Full Install** secenegini secin. Kurulum sirasinda:
   - Gerekli paketler (`zsh`, `git`, `nano`, `fzf`, `zoxide`, `bat`, `eza`, `curl`) `pacman` ile kurulur
   - Zsh yapilandirmasi uygulanir
   - SolukOS banner'i ve Konsole temasi ayarlanir
   - `soluk` komutu `~/.local/bin/soluk` olarak eklenir

5. Kurulum bitince terminal otomatik olarak Zsh'e gecer. Yeni bir terminal
   penceresi actiginizda SolukOS banner'ini goreceksiniz.

## Kurulumu Dogrulama

```
soluk version
soluk doctor
```

`doctor` komutu SolukOS dizini, paket veritabani ve paket yoneticisi gibi
temel bilesenlerin dogru kuruldugunu kontrol eder.

## Kaldirma

```
./install.sh
```

calistirip menuden **[3] Remove SolukOS** secenegini secin. Bu islem Zsh
yapilandirmanizi kurulum oncesi haline dondurur ve `~/.solukos` dizinini
siler.

## Sorun Giderme

- `soluk: command not found` hatasi aliyorsaniz `~/.local/bin`'in PATH'te
  oldugundan emin olun (SolukOS'un `config/zshrc`'si bunu otomatik ekler),
  sonra yeni bir terminal penceresi acin ya da `exec zsh` calistirin.
- Kurulum yarim kaldiysa `~/.solukos/logs/install.log` dosyasini kontrol edin.
