# İbare İçerik Şeması

İbare ekranları kitap veya ders adına bağlı kod içermez. Yeni içerik:

1. `assets/data/ibare/` altında bir JSON dosyası oluşturularak,
2. `assets/data/catalog.json` içindeki `ibareBooks` listesine eklenerek

uygulamaya alınır. Başlangıç şablonu:
[ibare-content-template.json](ibare-content-template.json).

## Yapı

```text
kitap
└── passages[]
    └── tokens[]
        └── analysis
            ├── fields
            └── details[]
```

- `arabic`: Öğrenciye “Harekeleri göster” açıkken sunulan tam biçim.
- `printedArabic`: Kitapta basıldığı biçim. Verilmezse `arabic` kullanılır.
- `punctuation`: Kelimenin ardından gelen noktalama.
- `gloss`: Kırık mana.
- `translation`: Pasajın toparlanmış manası.
- `analysis.kind`: Kelimenin üst başlığı.
- `analysis.fields`: Uygulamanın tanıdığı standart tahlil alanları.
- `analysis.details`: Kitaba özgü, standart dışı açıklamalar.

## Standart Tahlil Alanları

Alanlar JSON'da sabit anahtarlarla yazılır; Türkçe etiketleri uygulama üretir.

| Anahtar | Gösterilen etiket |
|---|---|
| `structure` | Yapısı |
| `wordForm` | Kelime biçimi |
| `root` | Kök |
| `singular` | Tekili |
| `derivedFrom` | Türediği fiil |
| `baseForm` | Aslı |
| `bab` | Bab |
| `pattern` | Vezin |
| `morphology` | Türü |
| `conjugation` | Çekim |
| `person` | Şahıs |
| `hiddenPronoun` | Gizli zamir |
| `pronoun` | Zamir |
| `referent` | Mercii |
| `transitivity` | Geçişlilik |
| `presentForm` | Muzârisi |
| `middleRadical` | Aynü’l-fiil |
| `numberType` | Sayı türü |
| `tamyiz` | Temyizi |
| `meaning` | Anlam |
| `turkish` | Türkçesi |
| `term` | Terim |
| `effect` | Etkisi |
| `syntax` | Cümledeki görev |
| `role` | Görevi |
| `construction` | Tamlama |
| `noun` | İsim |
| `nasb` | Nasb |
| `irab` | İ‘rab |
| `ellipsis` | Takdir |

Yeni standart alan gerekiyorsa önce `IbareField` enum'una eklenir. Tek kitaba
özgü alanlar için enum genişletilmez; `details` kullanılır.

## Kimlik ve Sıralama Kuralları

- Kitap, pasaj ve token kimlikleri kendi kapsamlarında benzersizdir.
- Pasajlar `order` alanına göre sıralanır.
- Token sırası JSON dizisindeki sıradır.
- `schemaVersion` şu an `1` olmalıdır.
- Boş başlık, Arapça metin, kırık mana veya tahlil türü kabul edilmez.

`npm run validate-seed` manifesti, dosya yollarını, kimlikleri ve alan
anahtarlarını doğrular.
