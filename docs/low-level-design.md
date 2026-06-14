# Low-Level Tasarım

Bu doküman mevcut Flutter MVP'nin teknik yapısını tarif eder. Amaç, sonraki geliştirmelerde veri, UI ve test sınırlarının kaybolmamasıdır.

Bu dosya yaşayan teknik tasarım kaydıdır. Mimari, veri akışı, model alanları, klasör yapısı veya test edilebilirlik kararları değiştiğinde aynı değişiklikle birlikte güncel tutulmalıdır.

Not: Bu doküman ve eşlik eden checklist/test kayıtları her zaman güncel tutulmalıdır; mimari veya veri akışında yapılan her değişiklik aynı commit içinde bu kayıtlara yansıtılmalıdır.

## 1. Mevcut Dosya Yapısı

```text
lib/main.dart
assets/data/emsile_seed.json
scripts/visual-check.js
test/widget_test.dart
docs/screenshots/
```

Mevcut uygulama kodu feature ve katman sınırlarına göre ayrılmıştır:

```text
lib/
  app/
    emsile_app.dart
    app_shell.dart
  data/
    emsile_repository.dart
    models.dart
  features/
    home/
    lessons/
    conjugation/
    practice/
    source/
  shared/
    theme/
      app_theme.dart
    widgets/
```

`shared/widgets` altında ortak sayfa, bilgi paneli ve Arapça sonuç kartı gibi tekrar kullanılan bileşenler bulunur.

## 2. Uygulama Başlatma Akışı

1. `main()` çalışır.
2. `EmsileApp` oluşturulur.
3. `EmsileRepository.load()` çağrılır.
4. `assets/data/emsile_seed.json` okunur.
5. JSON, `AppData` modeline parse edilir.
6. `PracticeQuestionGenerator`, `forms` listesinden çoktan seçmeli pratik sorularını üretir.
7. Veri hazırsa `AppShell(data: snapshot.data!)` render edilir.
8. Veri yüklenirken `LoadingScreen`, hata varsa `LoadErrorScreen` gösterilir.

## 3. Veri Katmanı

Veri kaynağı:

```text
assets/data/emsile_seed.json
```

Bu tercih şimdilik SQLite yerine daha uygun çünkü:

- Veri küçük ve statik.
- İçerik elle kontrol edilerek genişletilecek.
- Flutter asset olarak web, Android ve iOS'ta aynı şekilde paketlenebilir.
- Geliştirme sırasında diff okunabilir kalır.

SQLite ileride şu durumlarda mantıklı olur:

- Kullanıcı ilerlemesi kalıcı tutulacaksa.
- Çok sayıda kök/çekim üzerinde arama ve filtreleme gerekiyorsa.
- Offline kişisel notlar, favoriler ve tekrar geçmişi eklenecekse.

## 4. JSON Modeli

Kök yapı:

```json
{
  "lessons": [],
  "forms": []
}
```

`lessons` alanı ders listesini ve ders detayındaki temel açıklamayı taşır.

`forms` alanı çekim tablosunun ana veri kaynağıdır. Her form şu seçimlerle filtrelenir:

- `category`: `mazi`, `muzari`
- `voice`: `malum`, `mechul`
- `person`: `first`, `second`, `third`
- `number`: `singular`, `dual`, `plural`
- `gender`: `masculine`, `feminine`, `common`
- `pronounLabel`: kullanıcıya gösterilen şahıs etiketi

Çoktan seçmeli alıştırmalar seed JSON'da tek tek tutulmaz; çalışma anında `forms` listesinden üretilir.

## 5. Model Sınıfları

`AppData`

- `lessons`
- `forms`
- `practiceQuestions`

`Lesson`

- Ders listesi ve ders detayının kaynağıdır.
- `relatedCategory` ile ilgili çekim formlarına bağlanır.

`ConjugationForm`

- Çekim tablosu kartı, şahıs seçici ve tüm formlar listesinde kullanılır.
- `category`, `voice`, `person`, `number`, `gender` alanlarıyla tanımlanır.
- Arapça form ve Türkçe anlamı taşır.
- Kısa kural notu `rule` getter'ı ile bu alanlardan türetilir.

`PracticeQuestion`

- Pratik ekranındaki soru, seçenekler, doğru cevap ve açıklamayı taşır.
- Repository aşamasında `PracticeQuestionGenerator` tarafından üretilir.

`PracticeQuestionGenerator`

- Her çekim formu için en az iki soru üretir:
  - anlamı seç
  - şahsı seç
- Distractor seçeneklerini aynı `category` + `voice` grubundaki kardeş formlardan toplar.
- Aynı Arapça formun birden çok şahısta tekrar ettiği durumlarda kardeş filtrelemesini `candidate != form` mantığıyla yapar.

## 6. UI Katmanı

Ana ekranlar:

- `HomeScreen`
- `LessonsScreen`
- `LessonDetailScreen`
- `ConjugationScreen`
- `PracticeScreen`
- `SourceScreen`

Paylaşılan widgetlar:

- `AppPage`
- `FeaturedStudyCard`
- `StudyStep`
- `LessonTile`
- `ArabicResultCard`
- `CompactFormRow`
- `AnswerButton`
- `InfoPanel`

`AppPage`, tüm ekranlarda mobil merkezli sayfa iskeletini sağlar. `ConstrainedBox(maxWidth: 520)` ile webde de mobil okuma genişliği korunur.

## 7. Çekim Tablosu Davranışı

State:

- `_category`: Mâzi veya Muzâri
- `_voice`: Malum veya Meçhul
- `_selectedForm`: seçili şahsın `person + number + gender` kimliği

Filtre:

```dart
forms.where((form) => form.category == _category && form.voice == _voice)
```

Kategori veya bina değiştiğinde seçili şahıs indeksle değil kimlikle korunur. Yeni görünür grupta aynı `person + number + gender` eşleşmesi varsa o form aktif kalır; yoksa ilk görünür forma düşülür.

Şahıs seçimi ve tüm formlar görünümü artık seed sırasına bırakılmaz; PDF'deki muttaride düzenini izleyen sabit bir tablo şeması ile çizilir:

- sütunlar soldan sağa: `Çoğul`, `İkil`, `Tekil`
- satırlar yukarıdan aşağıya:
  - `3. Şahıs / Müzekker`
  - `3. Şahıs / Müennes`
  - `2. Şahıs / Müzekker`
  - `2. Şahıs / Müennes`
  - `1. Şahıs / Ortak`

Bu şema hem şahıs seçim tablosunda hem de tüm formlar tablosunda ortak kullanılır.

## 8. Arapça Metin Davranışı

Arapça formlar `Directionality(textDirection: TextDirection.rtl)` içinde render edilir.

Şimdilik font:

```dart
fontFamily: 'Times New Roman'
```

Bu kesin nihai karar değildir. Harekeli Arapça metin için ileride özel font seçimi yapılmalı ve Android/iOS üzerinde ayrıca doğrulanmalıdır.

## 9. Hata ve Boş Durumlar

Mevcut durum:

- JSON yükleme hatasında `LoadErrorScreen` gösterilir.
- Boş form listeleri için özel UI henüz yoktur.

Sıradaki iyileştirme:

- `forms.isEmpty` durumunda çekim tablosunda açıklayıcı boş durum göster.
- JSON parse hatalarında hangi alanın eksik olduğunu daha okunur raporla.

## 10. Refactor Notu

İlk kod organizasyonu refactor'ı tamamlandı. `lib/main.dart` artık sadece uygulamayı başlatır.

Tamamlanan taşıma:

1. Model ve repository sınıfları `lib/data/` altına taşındı.
2. Tema ve ortak widgetlar `lib/shared/` altına taşındı.
3. Ekranlar `lib/features/<feature>/` altına taşındı.
4. App shell ve bootstrap kodu `lib/app/` altına taşındı.
5. Test import yolları güncellendi.

Sıradaki teknik borç:

- Feature içindeki küçük bileşenleri ayrı dosyalara böl.
- Route/nav kararlarını ihtiyaç büyüdükçe ayrı bir navigation katmanına taşı.
