# Emsile Flutter Geliştirme Checklist

## 1. Proje Hazırlığı

- [ ] Flutter proje iskeletini oluştur.
- [ ] Web hedefini çalıştır.
- [ ] Android/iOS hedeflerinin ileride desteklenebileceğini doğrula.
- [ ] Temel klasör yapısını oluştur: `lib/features`, `lib/shared`, `lib/data`.
- [ ] Lint ve format ayarlarını ekle.

## 2. Tasarım Sistemi

- [ ] Renk paletini belirle.
- [ ] Türkçe metin fontunu belirle.
- [ ] Arapça metin fontunu belirle.
- [ ] Tema dosyasını oluştur.
- [ ] Buton, kart, segment kontrol ve liste stillerini standartlaştır.
- [ ] Mobil öncelikli spacing değerlerini belirle.

## 3. Veri Hazırlığı

- [ ] Yerel PDF kaynağını doğrula: `docs/Emsile_Ders_Notu_Zafer_ESEN_01.01.2025.pdf`.
- [ ] PDF kaynak bilgilerini uygulama içinde kullanılacak şekilde kaydet.
- [ ] İlk örnek fiili seç: `نصر`.
- [ ] Şahıs zamirleri veri modelini oluştur.
- [ ] Fiil-i mâzi malum çekimlerini yapılandır.
- [ ] Fiil-i mâzi meçhul çekimlerini yapılandır.
- [ ] Fiil-i muzâri malum çekimlerini yapılandır.
- [ ] Fiil-i muzâri meçhul çekimlerini yapılandır.
- [ ] Her form için Türkçe anlam alanı ekle.
- [ ] Verileri elle kontrol et.

## 4. Navigasyon

- [ ] Alt navigasyon yapısını kur.
- [ ] Ana Sayfa rotasını oluştur.
- [ ] Dersler rotasını oluştur.
- [ ] Çekim Tablosu rotasını oluştur.
- [ ] Alıştırma rotasını oluştur.
- [ ] Kaynak rotasını oluştur.

## 5. Ana Sayfa

- [ ] Uygulama başlığını ve kısa durum alanını tasarla.
- [ ] "Devam et" kartını oluştur.
- [ ] Günlük çalışma önerisi alanını ekle.
- [ ] Hızlı tekrar aksiyonunu ekle.
- [ ] Mobil ekranlarda taşma ve sıkışma testi yap.

## 6. Dersler

- [ ] Ders listesi ekranını oluştur.
- [ ] Ders kartı bileşenini oluştur.
- [ ] Ders detay ekranını oluştur.
- [ ] Ders detayında Arapça örnek ve Türkçe açıklama göster.
- [ ] Ders detayından çekim tablosuna geçiş ekle.
- [ ] Ders detayından alıştırmaya geçiş ekle.

## 7. Çekim Tablosu

- [ ] Kategori seçici oluştur: Mâzi, Muzâri, Nefy, Emir, İsimler.
- [ ] Bina seçici oluştur: Malum, Meçhul.
- [ ] Şahıs seçici oluştur.
- [ ] Sayı/cinsiyet seçici oluştur.
- [ ] Seçime göre Arapça formu büyük göster.
- [ ] Türkçe anlam ve kısa kural notu göster.
- [ ] Tüm formları listeleyen detay görünümü ekle.
- [ ] Sağdan sola yazım davranışını test et.

## 8. Alıştırma

- [ ] Kart çevirme alıştırmasını oluştur.
- [ ] Çoktan seçmeli alıştırmayı oluştur.
- [ ] Cevap kontrol mekanizmasını ekle.
- [ ] Doğru/yanlış geri bildirimlerini tasarla.
- [ ] Sonraki soru akışını ekle.
- [ ] İlk alıştırma veri setini `نصر` üzerinden oluştur.

## 9. Kaynak Ekranı

- [ ] Zafer ESEN kaynak bilgisini göster.
- [ ] Belge güncelleme tarihini göster: 01.01.2025.
- [ ] Kaynak bağlantısını göster.
- [ ] Kullanım notunu kısa ve açık şekilde göster.
- [ ] PDF açma veya dış bağlantı alanı ekle.

## 10. Mobil/Web Kalite Kontrol

- [ ] 360px genişlikte ekran testi yap.
- [ ] 390px genişlikte ekran testi yap.
- [ ] 430px genişlikte ekran testi yap.
- [ ] Masaüstü web önizlemede mobil merkezli görünümü doğrula.
- [ ] Arapça metinlerin taşmadığını doğrula.
- [ ] Buton metinlerinin sığdığını doğrula.
- [ ] Alt navigasyonun küçük ekranlarda kullanılabilir olduğunu doğrula.

## 11. Teknik Kalite

- [ ] `flutter analyze` çalıştır.
- [ ] `flutter test` çalıştır.
- [ ] Veri modelleri için temel unit test ekle.
- [ ] Çekim seçici için widget test ekle.
- [ ] Kod formatını çalıştır.

## 12. MVP Tamamlanma Kriterleri

- [ ] Uygulama webde açılıyor.
- [ ] Ana navigasyon çalışıyor.
- [ ] En az bir ders okunabiliyor.
- [ ] `نصر` için mâzi ve muzâri çekimleri görüntülenebiliyor.
- [ ] En az bir alıştırma tamamlanabiliyor.
- [ ] Kaynak bilgisi görünür.
- [ ] Mobil görünümde kritik taşma yok.
