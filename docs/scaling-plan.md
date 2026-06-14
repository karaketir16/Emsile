# Ölçeklenebilir Veri Tasarımı

Bu doküman, uygulamanın tek örnek fiilden tüm `Emsile-i Muhtelife` içeriğine ve ardından çok sayıda sülasi fiile genişleyebilmesi için önerilen veri mimarisini tanımlar.

Bu dosya yaşayan teknik tasarım kaydıdır. Veri şeması, içerik organizasyonu, import akışı veya ölçeklenme kararları değiştiğinde aynı değişiklikle birlikte güncel tutulmalıdır.

## 1. Problem Tanımı

Mevcut MVP veri modeli tek bir `forms[]` listesi ile iyi çalışır; ancak şu hedefler için yeterince ölçekli değildir:

- tek fiil yerine çok sayıda fiil eklemek
- `Emsile-i Muhtelife` ve `Emsile-i Muttaride` içeriklerini aynı veri kaynağında taşımak
- sülasi fiilleri kök, bab ve kalıp düzeyinde filtrelemek
- ileride arama, favori, tekrar geçmişi ve kullanıcı notları eklemek

Bu yüzden veri katmanı "ekranı besleyen sabit seed" olmaktan çıkıp "genişleyebilir içerik kataloğu" haline gelmelidir.

## 2. Önerilen Mimari

Önerilen yaklaşım: `normalized JSON + runtime composition + rule-based generation`

Bu yapıda veri tek bir büyük dosyada tutulmaz; bunun yerine birbirini tamamlayan birkaç kaynağa ayrılır:

1. `catalog`
2. `verbs`
3. `conjugationSource`
4. `runtime generators`
5. `runtime adapters`

Şimdilik JSON ile ilerlenir. Veri büyüdüğünde aynı model SQLite'a taşınabilir.

## 3. Dosya Organizasyonu

Önerilen yapı:

```text
assets/data/
  catalog.json
  verbs/
    nasara.json
    daraba.json
    fataha.json
```

### 3.1 catalog.json

Katalog dosyası uygulama seviyesindeki içerik kayıtlarını taşır:

- ders listesi
- fiil manifesti
- varsayılan fiil
- içerik sürümü

Örnek:

```json
{
  "version": 1,
  "defaultVerbId": "nasara",
  "lessons": [],
  "verbs": [
    {
      "id": "nasara",
      "root": "نصر",
      "title": "نصر",
      "assetPath": "assets/data/verbs/nasara.json",
      "group": "sulasi_mujarrad"
    }
  ]
}
```

### 3.2 verbs/<id>.json

Her fiil kendi dosyasında tutulur.

Önerilen bölümler:

- `meta`
- `muhtelifeEntries`
- `conjugationSource`

Bu ayrım önemlidir:

- `Muhtelife`: farklı kalıp ve türev türleri
- `Muttaride`: şahıslara göre çekilen tablolar
- `conjugationSource`: kıyasi çekimlerin hangi kuralla üretileceğini tarif eden kısa yapı

## 4. Veri Katmanları

### 4.1 VerbMeta

Fiilin sözlük ve katalog düzeyi bilgisini taşır:

- `id`
- `root`
- `letters`
- `title`
- `transliteration`
- `meaningSummary`
- `group`

### 4.2 MuhtelifeEntry

Emsile-i Muhtelife satırlarını taşır:

- `type`
- `label`
- `arabic`
- `meaning`
- `notes`
- `sortOrder`

Örnek türler:

- `fiil_mazi`
- `fiil_muzari`
- `masdar`
- `ism_fail`
- `ism_meful`
- `nefy_hal`
- `emr_hazir`

### 4.3 ConjugationSource

Kıyasi çekimleri veri tekrarı olmadan üretmek için kullanılır.

Örnek:

```json
{
  "conjugationSource": {
    "strategy": "generated",
    "generated": {
      "family": "sulasi_mujarrad",
      "verbClass": "sahih_salim",
      "bab": "nasara_yansuru",
      "lemma": {
        "mazi": "نَصَرَ",
        "muzari": "يَنْصُرُ"
      }
    }
  }
}
```

Bu yapı, yüzlerce fiilde tekrar edecek `category / voice / person / number / gender` satırlarını veri dosyasında tek tek yazma ihtiyacını azaltır.

### 4.4 Runtime MuttarideForm

Şahıslara göre çekim tablosu için gereken `ConjugationForm[]` listesi repository/generator tarafından runtime'da üretilir.

Bu alanlar UI ile uyumludur:

- `category`
- `voice`
- `person`
- `number`
- `gender`
- `pronounLabel`
- `arabic`
- `meaning`

## 5. Neden Bu Yapı

Bu yaklaşımın avantajları:

- yeni fiil eklemek kod yerine veri eklemek olur
- aynı UI birden çok fiil için yeniden kullanılabilir
- `muhtelife` ve `muttaride` içerikleri ayrı fakat ilişkili kalır
- kıyasi çekimlerde büyük veri tekrarını kaldırır
- tek fiili güncellemek küçük ve okunur diff üretir
- sonradan SQLite'a geçiş kolaylaşır

## 6. Runtime Composition

Uygulama JSON dosyalarını doğrudan UI modeli olarak kullanmaz.

Önerilen akış:

1. `catalog.json` yüklenir
2. varsayılan fiil veya seçilen fiil manifesti bulunur
3. ilgili `verbs/<id>.json` yüklenir
4. `conjugationSource` varsa muttaride çekimleri runtime'da generate edilir
5. verb verisi mevcut ekranların anlayacağı `AppData` benzeri runtime modele dönüştürülür
6. pratik soruları generated `muttarideForms` üzerinden üretilir

Bu sayede UI bir anda bütünüyle yeniden yazılmak zorunda kalmaz.

## 7. Geçiş Planı

### Faz 1

- `catalog.json` oluştur
- `verbs/nasara.json` oluştur
- repository'yi yeni yapıyı okuyacak hale getir
- mevcut çekim ekranını `nasara` üzerinden çalıştırmaya devam et

### Faz 2

- ilk `generated` conjugation strategy'sini ekle
- `nasara` için flat `muttarideForms` listesini kaldır
- `sahih_salim` + `nasara_yansuru` profiliyle runtime üretime geç

### Faz 3

- `Muhtelife Explorer` ekranı ekle
- muhtelife içeriklerini ayrı görünümde göster
- fiil listesi ekranını ekle

### Faz 4

- birden çok sülasi fiil ekle
- arama ve filtreleme ekle
- içerik doğrulamasını schema tabanlı sıkılaştır

### Faz 5

- gerekirse SQLite'a geç
- kullanıcı ilerleme verisini kalıcı tut

## 8. Uygulama Kararı

Bu proje için önerilen yol:

- hemen SQLite ile başlamamak
- fakat veri modelini SQLite-ready kurmak
- kısa vadede `normalized JSON + repository composition` ile ilerlemek
- `muttaride` tarafında mümkün olan çekimleri rule-based generate etmek
- semai veya istisnai alanlarda override/veri tabanlı yaklaşımı korumak

Bu karar, içerik henüz büyüme aşamasındayken diff okunabilirliğini ve veri düzenleme kolaylığını korur.
