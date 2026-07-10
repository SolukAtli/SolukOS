# SolukOS Kurulum Rehberi

## Gereksinimler

- Android cihaz
- [Termux](https://f-droid.org/en/packages/com.termux/) (F-Droid sürümü önerilir)
- Termux'ta `git` kurulu olması gerekir (kurulu değilse aşağıdaki adım yükler)

## Kurulum

1. Termux'u açın ve git'in kurulu olduğundan emin olun:

   ```
   pkg install git -y
   ```

2. Repoyu klonlayın:

   ```
   git clone https://github.com/SolukAtli/SolukOS.git
   cd SolukOS
   ```

3. Kurulum betiğini çalıştırılabilir yapıp başlatın:

   ```
   chmod +x install.sh
   ./install.sh
   ```

4. Menüden **[1] Full Install** seçeneğini seçin. Kurulum sırasında:
   - Gerekli paketler (`zsh`, `git`, `nano`) kurulur
   - Zsh yapılandırması uygulanır
   - SolukOS banner'ı ve teması ayarlanır
   - `soluk` komutu sisteme eklenir

5. Kurulum bitince terminal otomatik olarak Zsh'e geçer. Yeni bir Termux
   oturumu açtığınızda SolukOS banner'ını göreceksiniz.

## Kurulumu Doğrulama

```
soluk version
soluk doctor
```

`doctor` komutu SolukOS dizini, paket veritabanı ve paket yöneticisi gibi
temel bileşenlerin doğru kurulduğunu kontrol eder.

## Kaldırma

```
./install.sh
```

çalıştırıp menüden **[3] Remove SolukOS** seçeneğini seçin. Bu işlem Zsh
yapılandırmanızı kurulum öncesi haline döndürür ve `~/.solukos` dizinini
siler.

## Sorun Giderme

- `soluk: command not found` hatası alıyorsanız yeni bir Termux oturumu açın
  ya da `exec zsh` çalıştırın.
- Kurulum yarım kaldıysa `~/.solukos/logs/install.log` dosyasını kontrol edin.
