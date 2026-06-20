# Emsile Flutter

Mobil öncelikli Arapça sarf çalışma uygulaması.

🌐 **Canlı Demo (Web):** [karaketir16.github.io/Emsile](https://karaketir16.github.io/Emsile/)

## Ekran Görüntüleri

Uygulamanın mobil öncelikli arayüzünden görünümler:

<p align="center">
  <img src="docs/screenshots/01-home-mobile.png" width="24%" alt="Ana Sayfa" />
  <img src="docs/screenshots/05-lessons-mobile.png" width="24%" alt="Dersler" />
  <img src="docs/screenshots/06-lesson-detail-mobile.png" width="24%" alt="Ders Detayı" />
  <img src="docs/screenshots/02-table-mobile.png" width="24%" alt="Çekim Tablosu" />
</p>

<p align="center">
  <img src="docs/screenshots/04-pronouns-mobile.png" width="24%" alt="Zamir Tablosu" />
  <img src="docs/screenshots/07-practice-modes-mobile.png" width="24%" alt="Pratik Seçimi" />
  <img src="docs/screenshots/08-matching-practice-mobile.png" width="24%" alt="Eşleştirme" />
  <img src="docs/screenshots/03-practice-mobile.png" width="24%" alt="Çoktan Seçmeli" />
</p>

<p align="center">
  <img src="docs/screenshots/09-table-fill-practice-mobile.png" width="24%" alt="Tabloyu Doldur" />
  <img src="docs/screenshots/10-about-mobile.png" width="24%" alt="Hakkında" />
</p>

## Özellikler

- Muhtelife, Muttaride ve Şahıs Zamirleri dersleri
- Fiil, isim, masdar ve taaccüb kategorileri için çekim tabloları
- Ayrı ve bitişik zamir tabloları
- Filtrelenebilir çoktan seçmeli pratik
- Fiil ve isim tabloları için sürükle-bırak “Tabloyu Doldur” alıştırması
- Eşleştirme alıştırması (matching practice) modu
- Malum/meçhul, şahıs, sayı, cinsiyet ve kırık çoğul desteği

## Veri

Uygulama yerel JSON verisini kullanır:

```text
assets/data/catalog.json
assets/data/verbs/nasara.json
```

`نصر` fiilinin düzenli çekimleri çalışma anında `MuttarideGenerator` tarafından üretilir.

## Çalıştırma

```bash
flutter pub get
flutter run -d chrome
```

Farklı bir tarayıcı kullanmak için:

```bash
flutter run -d web-server
```

Terminalde gösterilen yerel adresi istediğiniz tarayıcıda açabilirsiniz.

## Kontroller

```bash
dart format lib test
flutter analyze
flutter test
flutter build web
npm run validate-seed
npm run visual-check
```

## Belgeler

- [Tasarım dokümanı](docs/design-document.md)
- [Düşük seviye tasarım](docs/low-level-design.md)
- [Test stratejisi](docs/testing.md)
- [Geliştirme checklist'i](docs/checklist.md)
- [Ölçeklenme planı](docs/scaling-plan.md)

Uygulama hazırlanırken Zafer ESEN tarafından hazırlanan Emsile Ders Notu'ndan faydalanılmıştır.
