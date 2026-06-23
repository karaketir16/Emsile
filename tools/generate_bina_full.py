#!/usr/bin/env python3
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets/data/ibare/bina"
BOOK = ROOT / "assets/data/ibare/bina.json"

ENTRIES = [
    ("sulasi_mezid_bir_harf", "Sülâsî Mezîd - Bir Harf", "İkinci Bab: Tef‘îl", "الْبَابُ الثَّانِي فَعَّلَ يُفَعِّلُ تَفْعِيلًا مَوْزُونُهُ فَرَّحَ يُفَرِّحُ تَفْرِيحًا وَعَلَامَتُهُ أَنْ يَكُونَ مَاضِيهِ عَلَى أَرْبَعَةِ أَحْرُفٍ بِزِيَادَةِ حَرْفٍ وَاحِدٍ بَيْنَ الْفَاءِ وَالْعَيْنِ مِنْ جِنْسِ عَيْنِ فِعْلِهِ وَبِنَاؤُهُ لِلتَّكْثِيرِ نَحْوُ طَوَّفَ زَيْدٌ الْكَعْبَةَ وَمَوَّتَ الْإِبِلَ وَغَلَّقَ زَيْدٌ الْبَابَ", "İkinci babın vezni فَعَّلَ يُفَعِّلُ تَفْعِيلًا, mevzunu فَرَّحَ يُفَرِّحُ تَفْرِيحًا’dır. Mâzisi, fâ ile ayn arasına aynü’l-fiil cinsinden bir harf eklenerek dört harfli olur. Çokluk bildirir; çokluk fiilde, fâilde veya mef‘ûlde bulunabilir."),
    ("sulasi_mezid_bir_harf", "Sülâsî Mezîd - Bir Harf", "Üçüncü Bab: Müfâ‘ale", "الْبَابُ الثَّالِثُ فَاعَلَ يُفَاعِلُ مُفَاعَلَةً وَفِعَالًا مَوْزُونُهُ قَاتَلَ يُقَاتِلُ مُقَاتَلَةً وَقِتَالًا وَعَلَامَتُهُ أَنْ يَكُونَ مَاضِيهِ عَلَى أَرْبَعَةِ أَحْرُفٍ بِزِيَادَةِ الْأَلِفِ بَيْنَ الْفَاءِ وَالْعَيْنِ وَبِنَاؤُهُ لِلْمُشَارَكَةِ بَيْنَ الِاثْنَيْنِ غَالِبًا وَقَدْ يَكُونُ لِلْوَاحِدِ نَحْوُ قَاتَلَ زَيْدٌ عَمْرًا وَقَاتَلَهُمُ اللَّهُ", "Üçüncü babın vezni فَاعَلَ يُفَاعِلُ مُفَاعَلَةً وَفِعَالًا’dır. Mâzisinde fâ ile ayn arasına elif eklenir. Çoğunlukla iki taraf arasındaki ortaklığı, bazen tek taraflı işi bildirir."),
    ("sulasi_mezid_iki_harf", "Sülâsî Mezîd - İki Harf", "Birinci Bab: İnfi‘âl", "النَّوْعُ الثَّانِي الْفِعْلُ الثُّلَاثِيُّ الْمَزِيدُ بِحَرْفَيْنِ وَهُوَ خَمْسَةُ أَبْوَابٍ الْبَابُ الْأَوَّلُ اِنْفَعَلَ يَنْفَعِلُ اِنْفِعَالًا مَوْزُونُهُ اِنْكَسَرَ يَنْكَسِرُ اِنْكِسَارًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ وَالنُّونِ فِي أَوَّلِهِ وَبِنَاؤُهُ لِلْمُطَاوَعَةِ نَحْوُ كَسَرْتُ الزُّجَاجَ فَانْكَسَرَ الزُّجَاجُ", "İki harf ilaveli sülâsî mezîd beş babdır. Birinci bab اِنْفَعَلَ يَنْفَعِلُ اِنْفِعَالًا veznidir. Başına hemze ve nûn eklenir; çoğunlukla mütâvaat bildirir."),
    ("sulasi_mezid_iki_harf", "Sülâsî Mezîd - İki Harf", "İkinci Bab: İfti‘âl", "الْبَابُ الثَّانِي اِفْتَعَلَ يَفْتَعِلُ اِفْتِعَالًا مَوْزُونُهُ اِجْتَمَعَ يَجْتَمِعُ اِجْتِمَاعًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ فِي أَوَّلِهِ وَالتَّاءِ بَيْنَ الْفَاءِ وَالْعَيْنِ وَبِنَاؤُهُ لِلْمُطَاوَعَةِ أَيْضًا نَحْوُ جَمَعْتُ الْإِبِلَ فَاجْتَمَعَتِ الْإِبِلُ", "İkinci bab اِفْتَعَلَ يَفْتَعِلُ اِفْتِعَالًا veznidir. Başına hemze, fâ ile ayn arasına tâ eklenir. Bu bab da mütâvaat için kullanılır."),
    ("sulasi_mezid_iki_harf", "Sülâsî Mezîd - İki Harf", "Üçüncü Bab: İf‘ilâl", "الْبَابُ الثَّالِثُ اِفْعَلَّ يَفْعَلُّ اِفْعِلَالًا مَوْزُونُهُ اِحْمَرَّ يَحْمَرُّ اِحْمِرَارًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ فِي أَوَّلِهِ وَحَرْفٍ مِنْ جِنْسِ لَامِ فِعْلِهِ فِي آخِرِهِ وَبِنَاؤُهُ لِمُبَالَغَةِ اللَّازِمِ وَقِيلَ لِلْأَلْوَانِ وَالْعُيُوبِ نَحْوُ اِحْمَرَّ زَيْدٌ وَاِعْوَرَّ زَيْدٌ", "Üçüncü bab اِفْعَلَّ يَفْعَلُّ اِفْعِلَالًا veznidir. Başına hemze, sonuna lâmü’l-fiil cinsinden bir harf eklenir. Lâzım fiilde mübalağa, özellikle renk ve kusur bildirir."),
    ("sulasi_mezid_iki_harf", "Sülâsî Mezîd - İki Harf", "Dördüncü Bab: Tefa‘‘ul", "الْبَابُ الرَّابِعُ تَفَعَّلَ يَتَفَعَّلُ تَفَعُّلًا مَوْزُونُهُ تَكَلَّمَ يَتَكَلَّمُ تَكَلُّمًا وَعَلَامَتُهُ زِيَادَةُ التَّاءِ فِي أَوَّلِهِ وَحَرْفٍ مِنْ جِنْسِ عَيْنِ فِعْلِهِ بَيْنَ الْفَاءِ وَالْعَيْنِ وَبِنَاؤُهُ لِلتَّكَلُّفِ نَحْوُ تَعَلَّمْتُ الْعِلْمَ مَسْأَلَةً بَعْدَ مَسْأَلَةٍ", "Dördüncü bab تَفَعَّلَ يَتَفَعَّلُ تَفَعُّلًا veznidir. Başına tâ, fâ ile ayn arasına aynü’l-fiil cinsinden bir harf eklenir. Bir şeyi aşamalı ve çaba göstererek elde etmeyi bildirir."),
    ("sulasi_mezid_iki_harf", "Sülâsî Mezîd - İki Harf", "Beşinci Bab: Tefâ‘ul", "الْبَابُ الْخَامِسُ تَفَاعَلَ يَتَفَاعَلُ تَفَاعُلًا مَوْزُونُهُ تَبَاعَدَ يَتَبَاعَدُ تَبَاعُدًا وَعَلَامَتُهُ زِيَادَةُ التَّاءِ فِي أَوَّلِهِ وَالْأَلِفِ بَيْنَ الْفَاءِ وَالْعَيْنِ وَبِنَاؤُهُ لِلْمُشَارَكَةِ بَيْنَ الِاثْنَيْنِ فَصَاعِدًا نَحْوُ تَبَاعَدَ زَيْدٌ عَنْ عَمْرٍو وَتَصَالَحَ الْقَوْمُ", "Beşinci bab تَفَاعَلَ يَتَفَاعَلُ تَفَاعُلًا veznidir. Başına tâ, fâ ile ayn arasına elif eklenir. İki veya daha çok taraf arasındaki ortaklığı bildirir."),
    ("sulasi_mezid_uc_harf", "Sülâsî Mezîd - Üç Harf", "Birinci Bab: İstif‘âl", "النَّوْعُ الثَّالِثُ الْفِعْلُ الثُّلَاثِيُّ الْمَزِيدُ بِثَلَاثَةِ أَحْرُفٍ وَهُوَ أَرْبَعَةُ أَبْوَابٍ الْبَابُ الْأَوَّلُ اِسْتَفْعَلَ يَسْتَفْعِلُ اِسْتِفْعَالًا مَوْزُونُهُ اِسْتَخْرَجَ يَسْتَخْرِجُ اِسْتِخْرَاجًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ وَالسِّينِ وَالتَّاءِ فِي أَوَّلِهِ وَبِنَاؤُهُ لِلتَّعْدِيَةِ غَالِبًا وَقَدْ يَكُونُ لَازِمًا وَقِيلَ لِطَلَبِ الْفِعْلِ نَحْوُ اِسْتَخْرَجَ زَيْدٌ الْمَالَ وَاِسْتَحْجَرَ الطِّينُ وَاِسْتَغْفَرَ اللَّهَ", "Üç harf ilaveli sülâsî mezîd dört babdır. Birinci bab اِسْتَفْعَلَ يَسْتَفْعِلُ اِسْتِفْعَالًا veznidir. Başına hemze, sîn ve tâ eklenir. Çoğunlukla geçişlilik, bazen lâzımlık ve fiili talep etme anlamı taşır."),
    ("sulasi_mezid_uc_harf", "Sülâsî Mezîd - Üç Harf", "İkinci Bab: İf‘î‘âl", "الْبَابُ الثَّانِي اِفْعَوْعَلَ يَفْعَوْعِلُ اِفْعِيعَالًا مَوْزُونُهُ اِعْشَوْشَبَ يَعْشَوْشِبُ اِعْشِيشَابًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ فِي أَوَّلِهِ وَحَرْفٍ مِنْ جِنْسِ عَيْنِ فِعْلِهِ وَالْوَاوِ بَيْنَ الْعَيْنِ وَاللَّامِ وَبِنَاؤُهُ لِمُبَالَغَةِ اللَّازِمِ يُقَالُ عَشُبَتِ الْأَرْضُ وَاِعْشَوْشَبَتِ الْأَرْضُ", "İkinci bab اِفْعَوْعَلَ يَفْعَوْعِلُ اِفْعِيعَالًا veznidir. Başına hemze, aynü’l-fiil cinsinden bir harf ve ayn ile lâm arasına vav eklenir. Lâzım fiilde mübalağa bildirir."),
    ("sulasi_mezid_uc_harf", "Sülâsî Mezîd - Üç Harf", "Üçüncü Bab: İf‘ivvâl", "الْبَابُ الثَّالِثُ اِفْعَوَّلَ يَفْعَوِّلُ اِفْعِوَّالًا مَوْزُونُهُ اِجْلَوَّذَ يَجْلَوِّذُ اِجْلِوَّاذًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ فِي أَوَّلِهِ وَوَاوَيْنِ بَيْنَ الْعَيْنِ وَاللَّامِ وَبِنَاؤُهُ لِمُبَالَغَةِ اللَّازِمِ يُقَالُ جَلَذَتِ الْإِبِلُ وَاِجْلَوَّذَتِ الْإِبِلُ", "Üçüncü bab اِفْعَوَّلَ يَفْعَوِّلُ اِفْعِوَّالًا veznidir. Başına hemze, ayn ile lâm arasına iki vav eklenir. Lâzım fiilde mübalağa bildirir."),
    ("sulasi_mezid_uc_harf", "Sülâsî Mezîd - Üç Harf", "Dördüncü Bab: İf‘îlâl", "الْبَابُ الرَّابِعُ اِفْعَالَّ يَفْعَالُّ اِفْعِيلَالًا مَوْزُونُهُ اِحْمَارَّ يَحْمَارُّ اِحْمِيرَارًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ فِي أَوَّلِهِ وَالْأَلِفِ بَيْنَ الْعَيْنِ وَاللَّامِ وَحَرْفٍ مِنْ جِنْسِ لَامِ فِعْلِهِ فِي آخِرِهِ وَبِنَاؤُهُ لِمُبَالَغَةِ اللَّازِمِ وَهُوَ أَبْلَغُ مِنْ بَابِ الِافْعِلَالِ نَحْوُ حَمُرَ زَيْدٌ وَاِحْمَرَّ زَيْدٌ وَاِحْمَارَّ زَيْدٌ", "Dördüncü bab اِفْعَالَّ يَفْعَالُّ اِفْعِيلَالًا veznidir. Başına hemze, ayn ile lâm arasına elif ve sona lâmü’l-fiil cinsinden bir harf eklenir. Lâzım fiilde mübalağa bildirir ve if‘ilâl babından daha kuvvetlidir."),
    ("rubai_mucerred", "Rubâî Mücerred", "Rubâî Mücerred Babı", "بَابُ الرُّبَاعِيِّ الْمُجَرَّدِ وَهُوَ بَابٌ وَاحِدٌ فَعْلَلَ يُفَعْلِلُ فَعْلَلَةً وَفِعْلَالًا مَوْزُونُهُ دَحْرَجَ يُدَحْرِجُ دَحْرَجَةً وَدِحْرَاجًا وَعَلَامَتُهُ أَنْ يَكُونَ مَاضِيهِ عَلَى أَرْبَعَةِ أَحْرُفٍ جَمِيعُ حُرُوفِهِ أَصْلِيَّةٌ وَبِنَاؤُهُ لِلتَّعْدِيَةِ غَالِبًا وَقَدْ يَكُونُ لَازِمًا نَحْوُ دَحْرَجَ زَيْدٌ الْحَجَرَ وَدَرْبَخَ زَيْدٌ", "Rubâî mücerred tek babdır: فَعْلَلَ يُفَعْلِلُ. Dört harfinin tamamı aslîdir. Çoğunlukla müteaddi, bazen lâzım kullanılır."),
    ("rubai_mulhak", "Rubâîye Mülhak Bablar", "Birinci Bab: Fev‘ale", "الْبَابُ الْأَوَّلُ فَوْعَلَ يُفَوْعِلُ فَوْعَلَةً وَفِيعَالًا مَوْزُونُهُ حَوْقَلَ يُحَوْقِلُ حَوْقَلَةً وَحِيقَالًا وَعَلَامَتُهُ زِيَادَةُ الْوَاوِ بَيْنَ الْفَاءِ وَالْعَيْنِ وَبِنَاؤُهُ لِلَّازِمِ نَحْوُ حَوْقَلَ زَيْدٌ", "Rubâîye mülhak birinci bab فَوْعَلَ يُفَوْعِلُ’dür. Fâ ile ayn arasına vav eklenir ve lâzım anlam taşır."),
    ("rubai_mulhak", "Rubâîye Mülhak Bablar", "İkinci Bab: Fey‘ale", "الْبَابُ الثَّانِي فَيْعَلَ يُفَيْعِلُ فَيْعَلَةً وَفِيعَالًا مَوْزُونُهُ بَيْطَرَ يُبَيْطِرُ بَيْطَرَةً وَبِيطَارًا وَعَلَامَتُهُ زِيَادَةُ الْيَاءِ بَيْنَ الْفَاءِ وَالْعَيْنِ وَبِنَاؤُهُ لِلتَّعْدِيَةِ فَقَطْ نَحْوُ بَيْطَرَ زَيْدٌ الْقَلَمَ أَيْ شَقَّهُ", "İkinci bab فَيْعَلَ يُفَيْعِلُ’dür. Fâ ile ayn arasına yâ eklenir ve yalnız müteaddi kullanılır."),
    ("rubai_mulhak", "Rubâîye Mülhak Bablar", "Üçüncü Bab: Fa‘vele", "الْبَابُ الثَّالِثُ فَعْوَلَ يُفَعْوِلُ فَعْوَلَةً وَفِعْوَالًا مَوْزُونُهُ جَهْوَرَ يُجَهْوِرُ جَهْوَرَةً وَجِهْوَارًا وَعَلَامَتُهُ زِيَادَةُ الْوَاوِ بَيْنَ الْعَيْنِ وَاللَّامِ وَبِنَاؤُهُ لِلتَّعْدِيَةِ أَيْضًا نَحْوُ جَهْوَرَ زَيْدٌ الْقُرْآنَ", "Üçüncü bab فَعْوَلَ يُفَعْوِلُ’dür. Ayn ile lâm arasına vav eklenir ve müteaddi kullanılır."),
    ("rubai_mulhak", "Rubâîye Mülhak Bablar", "Dördüncü Bab: Fa‘yele", "الْبَابُ الرَّابِعُ فَعْيَلَ يُفَعْيِلُ فَعْيَلَةً وَفِعْيَالًا مَوْزُونُهُ عَثْيَرَ يُعَثْيِرُ عَثْيَرَةً وَعِثْيَارًا وَعَلَامَتُهُ زِيَادَةُ الْيَاءِ بَيْنَ الْعَيْنِ وَاللَّامِ وَبِنَاؤُهُ لِلَّازِمِ نَحْوُ عَثْيَرَ زَيْدٌ أَيْ طَلَعَ", "Dördüncü bab فَعْيَلَ يُفَعْيِلُ’dür. Ayn ile lâm arasına yâ eklenir ve lâzım kullanılır."),
    ("rubai_mulhak", "Rubâîye Mülhak Bablar", "Beşinci Bab: Fa‘lele", "الْبَابُ الْخَامِسُ فَعْلَلَ يُفَعْلِلُ فَعْلَلَةً وَفِعْلَالًا مَوْزُونُهُ جَلْبَبَ يُجَلْبِبُ جَلْبَبَةً وَجِلْبَابًا وَعَلَامَتُهُ زِيَادَةُ حَرْفٍ وَاحِدٍ مِنْ جِنْسِ لَامِ فِعْلِهِ فِي آخِرِهِ وَبِنَاؤُهُ لِلتَّعْدِيَةِ فَقَطْ نَحْوُ جَلْبَبَ زَيْدٌ أَيْ لَبِسَ الْجِلْبَابَ", "Beşinci bab فَعْلَلَ يُفَعْلِلُ’dür. Sona lâmü’l-fiil cinsinden bir harf eklenir ve yalnız müteaddi kullanılır."),
    ("rubai_mulhak", "Rubâîye Mülhak Bablar", "Altıncı Bab: Fa‘lâ", "الْبَابُ السَّادِسُ فَعْلَى يُفَعْلِي فَعْلَيَةً وَفَعْلَاءً مَوْزُونُهُ سَلْقَى يُسَلْقِي سَلْقَيَةً وَسَلْقَاءً وَعَلَامَتُهُ زِيَادَةُ الْيَاءِ فِي آخِرِهِ وَبِنَاؤُهُ لِلَّازِمِ فَقَطْ نَحْوُ سَلْقَى زَيْدٌ أَيْ نَامَ عَلَى قَفَاهُ وَمَعْنَى الْإِلْحَاقِ اِتِّحَادُ الْمَصْدَرَيْنِ", "Altıncı bab فَعْلَى يُفَعْلِي’dir. Sonuna yâ eklenir ve yalnız lâzım kullanılır. İlhak, iki masdar kalıbının aynı olmasıdır."),
    ("rubai_mezid", "Rubâî Mezîd", "Bir Harf İlave: Tefa‘lül", "أَنْوَاعُ الرُّبَاعِيِّ الْمَزِيدِ ثَلَاثَةٌ النَّوْعُ الْأَوَّلُ الرُّبَاعِيُّ الْمَزِيدُ بِحَرْفٍ وَهُوَ بَابٌ وَاحِدٌ تَفَعْلَلَ يَتَفَعْلَلُ تَفَعْلُلًا مَوْزُونُهُ تَدَحْرَجَ يَتَدَحْرَجُ تَدَحْرُجًا وَعَلَامَتُهُ زِيَادَةُ التَّاءِ فِي أَوَّلِهِ وَبِنَاؤُهُ لِلْمُطَاوَعَةِ نَحْوُ دَحْرَجْتُ الْحَجَرَ فَتَدَحْرَجَ الْحَجَرُ", "Rubâî mezîd üç kısımdır. Bir harf ilaveli kısmın tek babı تَفَعْلَلَ يَتَفَعْلَلُ’dür. Başına tâ eklenir ve mütâvaat bildirir."),
    ("rubai_mezid", "Rubâî Mezîd", "İki Harf İlave - Birinci Bab", "النَّوْعُ الثَّانِي الرُّبَاعِيُّ الْمَزِيدُ بِحَرْفَيْنِ وَهُوَ بَابَانِ الْبَابُ الْأَوَّلُ اِفْعَنْلَلَ يَفْعَنْلِلُ اِفْعِنْلَالًا مَوْزُونُهُ اِحْرَنْجَمَ يَحْرَنْجِمُ اِحْرِنْجَامًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ فِي أَوَّلِهِ وَالنُّونِ بَيْنَ الْعَيْنِ وَاللَّامِ الْأُولَى وَبِنَاؤُهُ لِلْمُطَاوَعَةِ نَحْوُ حَرْجَمْتُ الْإِبِلَ فَاحْرَنْجَمَتِ الْإِبِلُ", "İki harf ilaveli rubâî mezîdin birinci babı اِفْعَنْلَلَ يَفْعَنْلِلُ’dür. Başına hemze, ayn ile ilk lâm arasına nûn eklenir ve mütâvaat bildirir."),
    ("rubai_mezid", "Rubâî Mezîd", "İki Harf İlave - İkinci Bab", "الْبَابُ الثَّانِي اِفْعَلَلَّ يَفْعَلِلُّ اِفْعِلَالًّا مَوْزُونُهُ اِقْشَعَرَّ يَقْشَعِرُّ اِقْشِعْرَارًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ فِي أَوَّلِهِ وَحَرْفٍ مِنْ جِنْسِ اللَّامِ الثَّانِيَةِ فِي آخِرِهِ وَبِنَاؤُهُ لِمُبَالَغَةِ اللَّازِمِ يُقَالُ قَشْعَرَ جِلْدُ الرَّجُلِ وَاِقْشَعَرَّ جِلْدُ الرَّجُلِ", "İkinci bab اِفْعَلَلَّ يَفْعَلِلُّ’dür. Başına hemze, sonuna ikinci lâm cinsinden bir harf eklenir. Lâzım fiilde mübalağa bildirir."),
    ("rubai_mezid_mulhak", "Rubâî Mezîd Mülhakları", "Birinci Bab: Tecelbebe", "الْبَابُ الْأَوَّلُ تَفَعْلَلَ يَتَفَعْلَلُ تَفَعْلُلًا مَوْزُونُهُ تَجَلْبَبَ يَتَجَلْبَبُ تَجَلْبُبًا وَعَلَامَتُهُ زِيَادَةُ التَّاءِ فِي أَوَّلِهِ وَحَرْفٍ مِنْ جِنْسِ لَامِ فِعْلِهِ فِي آخِرِهِ وَبِنَاؤُهُ لِلَّازِمِ نَحْوُ تَجَلْبَبَ زَيْدٌ", "Rubâî mezîd mülhaklarının birinci babında başa tâ, sona lâm cinsinden bir harf eklenir ve lâzım kullanılır."),
    ("rubai_mezid_mulhak", "Rubâî Mezîd Mülhakları", "İkinci Bab: Tecavrabe", "الْبَابُ الثَّانِي تَفَوْعَلَ يَتَفَوْعَلُ تَفَوْعُلًا مَوْزُونُهُ تَجَوْرَبَ يَتَجَوْرَبُ تَجَوْرُبًا وَعَلَامَتُهُ زِيَادَةُ التَّاءِ فِي أَوَّلِهِ وَالْوَاوِ بَيْنَ الْفَاءِ وَالْعَيْنِ وَبِنَاؤُهُ لِلَّازِمِ نَحْوُ تَجَوْرَبَ زَيْدٌ", "İkinci bab تَفَوْعَلَ يَتَفَوْعَلُ’dür. Başa tâ, fâ ile ayn arasına vav eklenir ve lâzım kullanılır."),
    ("rubai_mezid_mulhak", "Rubâî Mezîd Mülhakları", "Üçüncü Bab: Teşeytane", "الْبَابُ الثَّالِثُ تَفَيْعَلَ يَتَفَيْعَلُ تَفَيْعُلًا مَوْزُونُهُ تَشَيْطَنَ يَتَشَيْطَنُ تَشَيْطُنًا وَعَلَامَتُهُ زِيَادَةُ التَّاءِ فِي أَوَّلِهِ وَالْيَاءِ بَيْنَ الْفَاءِ وَالْعَيْنِ وَبِنَاؤُهُ لِلَّازِمِ نَحْوُ تَشَيْطَنَ زَيْدٌ", "Üçüncü bab تَفَيْعَلَ يَتَفَيْعَلُ’dür. Başa tâ, fâ ile ayn arasına yâ eklenir ve lâzım kullanılır."),
    ("rubai_mezid_mulhak", "Rubâî Mezîd Mülhakları", "Dördüncü Bab: Terehveke", "الْبَابُ الرَّابِعُ تَفَعْوَلَ يَتَفَعْوَلُ تَفَعْوُلًا مَوْزُونُهُ تَرَهْوَكَ يَتَرَهْوَكُ تَرَهْوُكًا وَعَلَامَتُهُ زِيَادَةُ التَّاءِ فِي أَوَّلِهِ وَالْوَاوِ بَيْنَ الْعَيْنِ وَاللَّامِ وَبِنَاؤُهُ لِلَّازِمِ نَحْوُ تَرَهْوَكَ زَيْدٌ", "Dördüncü bab تَفَعْوَلَ يَتَفَعْوَلُ’dür. Başa tâ, ayn ile lâm arasına vav eklenir ve lâzım kullanılır."),
    ("rubai_mezid_mulhak", "Rubâî Mezîd Mülhakları", "Beşinci Bab: Teselkâ", "الْبَابُ الْخَامِسُ تَفَعْلَى يَتَفَعْلَى تَفَعْلِيًا مَوْزُونُهُ تَسَلْقَى يَتَسَلْقَى تَسَلْقِيًا وَعَلَامَتُهُ زِيَادَةُ التَّاءِ فِي أَوَّلِهِ وَالْيَاءِ فِي آخِرِهِ وَبِنَاؤُهُ لِلَّازِمِ نَحْوُ تَسَلْقَى زَيْدٌ أَيْ نَامَ عَلَى قَفَاهُ", "Beşinci bab تَفَعْلَى يَتَفَعْلَى’dır. Başa tâ, sona yâ eklenir ve lâzım kullanılır."),
    ("rubai_mezid_tavabi", "Rubâî Mezîd Mülhaklarının Tâbileri", "Birinci Bab: İk‘ansese", "تَوَابِعُ مُلْحَقَاتِ الرُّبَاعِيِّ الْمَزِيدِ بَابَانِ الْبَابُ الْأَوَّلُ اِفْعَنْلَلَ يَفْعَنْلِلُ اِفْعِنْلَالًا مَوْزُونُهُ اِقْعَنْسَسَ يَقْعَنْسِسُ اِقْعِنْسَاسًا وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ وَالنُّونِ وَحَرْفٍ مِنْ جِنْسِ لَامِ فِعْلِهِ وَبِنَاؤُهُ لِمُبَالَغَةِ اللَّازِمِ يُقَالُ قَعَسَ الرَّجُلُ وَاِقْعَنْسَسَ الرَّجُلُ", "Rubâî mezîd mülhaklarının iki tâbii vardır. Birinci bab اِفْعَنْلَلَ يَفْعَنْلِلُ’dür ve lâzım fiilde mübalağa bildirir."),
    ("rubai_mezid_tavabi", "Rubâî Mezîd Mülhaklarının Tâbileri", "İkinci Bab: İslenkâ", "الْبَابُ الثَّانِي اِفْعَنْلَى يَفْعَنْلِي اِفْعِنْلَاءً مَوْزُونُهُ اِسْلَنْقَى يَسْلَنْقِي اِسْلِنْقَاءً وَعَلَامَتُهُ زِيَادَةُ الْهَمْزَةِ فِي أَوَّلِهِ وَالنُّونِ بَيْنَ الْعَيْنِ وَاللَّامِ وَالْيَاءِ فِي آخِرِهِ وَبِنَاؤُهُ لِلَّازِمِ نَحْوُ اِسْلَنْقَى زَيْدٌ", "İkinci bab اِفْعَنْلَى يَفْعَنْلِي’dir. Başa hemze, ayn ile lâm arasına nûn ve sona yâ eklenir; lâzım kullanılır."),
    ("fiil_taksimleri", "Fiilin Kısımları", "Sekiz Kısım", "اِعْلَمْ أَنَّ الْفِعْلَ الْمُنْحَصِرَ فِي هَذِهِ الْأَبْوَابِ إِمَّا ثُلَاثِيٌّ مُجَرَّدٌ سَالِمٌ نَحْوُ كَرُمَ أَوْ غَيْرُ سَالِمٍ نَحْوُ وَعَدَ وَإِمَّا ثُلَاثِيٌّ مَزِيدٌ فِيهِ سَالِمٌ نَحْوُ أَكْرَمَ أَوْ غَيْرُ سَالِمٍ نَحْوُ أَوْعَدَ وَإِمَّا رُبَاعِيٌّ مُجَرَّدٌ سَالِمٌ نَحْوُ دَحْرَجَ أَوْ غَيْرُ سَالِمٍ نَحْوُ وَسْوَسَ وَزَلْزَلَ وَإِمَّا رُبَاعِيٌّ مَزِيدٌ فِيهِ سَالِمٌ نَحْوُ تَدَحْرَجَ أَوْ غَيْرُ سَالِمٍ نَحْوُ تَوَسْوَسَ وَيُقَالُ لَهَا الْأَقْسَامُ الثَّمَانِيَةُ", "Fiiller sülâsî veya rubâî; mücerred veya mezîd; sâlim veya gayrisâlim olmalarına göre sekiz kısma ayrılır."),
    ("fiil_taksimleri", "Fiilin Kısımları", "Sahih ve Mu‘tel", "وَاعْلَمْ أَنَّ كُلَّ فِعْلٍ إِمَّا صَحِيحٌ وَهُوَ الَّذِي لَيْسَ فِي مُقَابَلَةِ فَائِهِ وَعَيْنِهِ وَلَامِهِ حَرْفٌ مِنْ حُرُوفِ الْعِلَّةِ نَحْوُ نَصَرَ وَإِمَّا مُعْتَلٌّ وَهُوَ الَّذِي يَكُونُ فِي مُقَابَلَةِ فَائِهِ أَوْ عَيْنِهِ أَوْ لَامِهِ حَرْفٌ مِنْ حُرُوفِ الْعِلَّةِ نَحْوُ وَعَدَ وَقَالَ وَطَغَى", "Her fiil ya sahihtir ya da mu‘teldir. Aslî harflerinde illet harfi bulunmayan fiil sahih; bulunan fiil mu‘teldir."),
    ("mu_tel", "Mu‘tel Fiil", "Misâl, Ecvef, Nâkıs ve Lefîf", "أَقْسَامُ الْفِعْلِ الْمُعْتَلِّ مِثَالٌ وَهُوَ الَّذِي فَاؤُهُ حَرْفُ عِلَّةٍ نَحْوُ وَعَدَ وَيَسَرَ وَأَجْوَفُ وَهُوَ الَّذِي عَيْنُهُ حَرْفُ عِلَّةٍ نَحْوُ قَالَ وَكَالَ وَنَاقِصٌ وَهُوَ الَّذِي لَامُهُ حَرْفُ عِلَّةٍ نَحْوُ غَزَا وَرَمَى وَلَفِيفٌ وَهُوَ مَا فِيهِ حَرْفَانِ مِنْ حُرُوفِ الْعِلَّةِ فَالْمَقْرُونُ نَحْوُ طَوَى وَالْمَفْرُوقُ نَحْوُ وَقَى", "Mu‘tel fiil; ilk aslî harfi illetli ise misâl, ortası illetli ise ecvef, sonu illetli ise nâkıs, iki illet harfi taşıyorsa lefîftir. Lefîf, makrûn ve mefrûk olmak üzere ikiye ayrılır."),
    ("mudaaf_idgam", "Mudaaf ve İdgam", "Mudaafın Tanımı", "وَإِمَّا مُضَاعَفٌ وَهُوَ الَّذِي عَيْنُهُ وَلَامُهُ مِنْ جِنْسٍ وَاحِدٍ نَحْوُ مَدَّ أَصْلُهُ مَدَدَ حُذِفَتْ حَرَكَةُ الدَّالِ الْأُولَى ثُمَّ أُدْغِمَتِ الدَّالُ الْأُولَى فِي الثَّانِيَةِ وَالْإِدْغَامُ إِدْخَالُ أَحَدِ الْمُتَجَانِسَيْنِ فِي الْآخَرِ وَهُوَ ثَلَاثَةُ أَنْوَاعٍ", "Aynü’l-fiili ile lâmü’l-fiili aynı cinsten olan fiile mudaaf denir. İdgam, aynı cinsten iki harften birini diğerine katmaktır ve üç çeşittir."),
    ("mudaaf_idgam", "Mudaaf ve İdgam", "Vâcip İdgam", "النَّوْعُ الْأَوَّلُ الْإِدْغَامُ الْوَاجِبُ وَهُوَ أَنْ يَكُونَ الْحَرْفَانِ الْمُتَجَانِسَانِ مُتَحَرِّكَيْنِ أَوْ يَكُونَ الْحَرْفُ الْأَوَّلُ سَاكِنًا وَالثَّانِي مُتَحَرِّكًا نَحْوُ مَدَّ يَمُدُّ مَدًّا", "İki aynı cins harf harekeli olduğunda veya birincisi sâkin, ikincisi harekeli olduğunda idgam vâciptir."),
    ("mudaaf_idgam", "Mudaaf ve İdgam", "Câiz İdgam", "النَّوْعُ الثَّانِي الْإِدْغَامُ الْجَائِزُ وَهُوَ أَنْ يَكُونَ الْحَرْفُ الْأَوَّلُ مِنَ الْمُتَجَانِسَيْنِ مُتَحَرِّكًا وَالْحَرْفُ الثَّانِي سَاكِنًا بِسُكُونٍ عَارِضٍ نَحْوُ لَمْ يَمُدَّ أَصْلُهُ لَمْ يَمْدُدْ فَيَجُوزُ بِالْإِدْغَامِ وَبِالْفَكِّ", "İlk harf harekeli, ikinci harf ârızî sükûnla sâkin olduğunda idgam câizdir; idgamlı ve çözülmüş iki okuyuş da mümkündür."),
    ("mudaaf_idgam", "Mudaaf ve İdgam", "İdgamın İmkânsız Olduğu Yer", "النَّوْعُ الثَّالِثُ الْإِدْغَامُ الْمُمْتَنِعُ وَهُوَ أَنْ يَكُونَ الْأَوَّلُ مِنَ الْمُتَجَانِسَيْنِ مُتَحَرِّكًا وَالثَّانِي سَاكِنًا بِسُكُونٍ أَصْلِيٍّ نَحْوُ مَدَدْتُ إِلَى مَدَدْنَ", "İlk harf harekeli, ikinci harf aslî sükûnla sâkin olduğunda idgam yapılamaz."),
    ("mahmuz", "Mehmuz Fiil", "Mehmûzü’l-fâ, Mehmûzü’l-ayn ve Mehmûzü’l-lâm", "وَإِمَّا مَهْمُوزٌ وَهُوَ الَّذِي أَحَدُ حُرُوفِهِ الْأَصْلِيَّةِ هَمْزَةٌ نَحْوُ أَخَذَ وَسَأَلَ وَقَرَأَ فَإِنْ كَانَتِ الْهَمْزَةُ فِي مُقَابَلَةِ فَائِهِ سُمِّيَ مَهْمُوزَ الْفَاءِ نَحْوُ أَخَذَ وَإِنْ كَانَتْ فِي مُقَابَلَةِ عَيْنِهِ سُمِّيَ مَهْمُوزَ الْعَيْنِ نَحْوُ سَأَلَ وَإِنْ كَانَتْ فِي مُقَابَلَةِ لَامِهِ سُمِّيَ مَهْمُوزَ اللَّامِ نَحْوُ قَرَأَ", "Aslî harflerinden biri hemze olan fiile mehmuz denir. Hemze ilk harfteyse mehmûzü’l-fâ, ortadaysa mehmûzü’l-ayn, sondaysa mehmûzü’l-lâm adını alır."),
    ("hatime", "Hâtime", "Yedi Kısım ve Sonuç", "وَيُقَالُ لِهَذِهِ الْأَقْسَامِ الْأَقْسَامُ السَّبْعَةُ يَجْمَعُهَا هَذَا الْبَيْتُ صَحِيحٌ مِثَالٌ مُضَاعَفٌ أَجْوَفُ نَاقِصٌ لَفِيفٌ مَهْمُوزٌ وَاللَّهُ وَرَسُولُهُ أَعْلَمُ بِالصَّوَابِ النِّهَايَةُ", "Fiillerin yedi temel kısmı sahih, misâl, mudaaf, ecvef, nâkıs, lefîf ve mehmuzdur. Doğrusunu Allah ve Resulü en iyi bilir. Son."),
]

GLOSSES = {
    "الْبَابُ": "Bab", "بَابُ": "Babı", "الْأَوَّلُ": "Birinci", "الْأَوَّلِ": "Birinci",
    "الثَّانِي": "İkinci", "الثَّالِثُ": "Üçüncü", "الرَّابِعُ": "Dördüncü",
    "الْخَامِسُ": "Beşinci", "السَّادِسُ": "Altıncı", "وَهُوَ": "Ve o",
    "وَهِيَ": "Ve o", "وَعَلَامَتُهُ": "Ve alâmeti", "أَنْ": "-mesi",
    "يَكُونَ": "Olması", "مَاضِيهِ": "Mâzisi", "عَلَى": "Üzere", "فِي": "İçinde",
    "أَوَّلِهِ": "Başında", "آخِرِهِ": "Sonunda", "بَيْنَ": "Arasında", "مِنْ": "-den",
    "جِنْسِ": "Cinsinden", "فِعْلِهِ": "Fiilinin", "وَبِنَاؤُهُ": "Ve kullanılışı",
    "لِلتَّعْدِيَةِ": "Geçişlilik içindir", "لِلَّازِمِ": "Lâzımlık içindir",
    "لِلْمُطَاوَعَةِ": "Mütâvaat içindir", "لِلْمُشَارَكَةِ": "Ortaklık içindir",
    "لِمُبَالَغَةِ": "Mübalağa içindir", "غَالِبًا": "Çoğunlukla", "أَيْضًا": "Ayrıca",
    "وَقَدْ": "Ve bazen", "نَحْوُ": "Örneğin", "مَوْزُونُهُ": "Mevzunu",
    "زِيَادَةُ": "Eklenmesi", "بِزِيَادَةِ": "Eklenmesiyle", "الْهَمْزَةِ": "Hemzenin",
    "التَّاءِ": "Tânın", "النُّونِ": "Nûnun", "الْوَاوِ": "Vavın", "الْيَاءِ": "Yânın",
    "الْأَلِفِ": "Elifin", "الْفَاءِ": "Fânın", "الْعَيْنِ": "Aynın", "اللَّامِ": "Lâmın",
    "حَرْفٍ": "Bir harf", "حَرْفٌ": "Bir harf", "أَحْرُفٍ": "Harf", "ثَلَاثَةُ": "Üç",
    "أَرْبَعَةُ": "Dört", "خَمْسَةُ": "Beş", "سِتَّةُ": "Altı", "أَبْوَابٍ": "Bab",
    "النَّوْعُ": "Kısım", "الْفِعْلُ": "Fiil", "الثُّلَاثِيُّ": "Sülâsî",
    "الرُّبَاعِيُّ": "Rubâî", "الْمَزِيدُ": "Mezîd", "الْمُجَرَّدِ": "Mücerred",
    "سَالِمٌ": "Sâlim", "صَحِيحٌ": "Sahih", "مُعْتَلٌّ": "Mu‘tel",
    "مِثَالٌ": "Misâl", "أَجْوَفُ": "Ecvef", "نَاقِصٌ": "Nâkıs", "لَفِيفٌ": "Lefîf",
    "مُضَاعَفٌ": "Mudaaf", "مَهْمُوزٌ": "Mehmuz", "أَصْلُهُ": "Aslı",
    "الْإِدْغَامُ": "İdgam", "الْوَاجِبُ": "Vâcip", "الْجَائِزُ": "Câiz",
    "الْمُمْتَنِعُ": "İmkânsız", "أَيْ": "Yani", "اللَّهُ": "Allah", "زَيْدٌ": "Zeyd",
}

PUNCTUATION = {".", "،", "؛", ":", "؟"}

def normalize_key(word):
    return word.rstrip("،؛:.؟")

def token_kind(word):
    bare = normalize_key(word)
    if bare in {"مِنْ", "فِي", "عَلَى", "إِلَى", "عَنْ", "بَيْنَ"}:
        return "Harf-i cer"
    if bare in {"أَنْ", "لَمْ", "إِمَّا", "أَوْ", "إِنْ"}:
        return "Harf"
    if bare.startswith(("يَ", "يُ", "تَ", "أَ", "اِ", "اِنْ", "اِسْتَ")):
        return "Fiil / kalıp"
    if bare.startswith("وَ"):
        return "Bağlaç + kelime"
    return "İsim / kelime"

def make_passage(order, title, arabic, translation):
    words = arabic.split()
    tokens = []
    for index, raw in enumerate(words, 1):
        punctuation = raw[-1] if raw[-1:] in PUNCTUATION else ""
        word = raw[:-1] if punctuation else raw
        key = normalize_key(word)
        gloss = GLOSSES.get(key, key)
        if word.startswith("وَ") and not gloss.startswith("Ve "):
            gloss = f"Ve {gloss}"
        tokens.append({
            "id": f"p{order}_t{index}",
            "arabic": word,
            **({"punctuation": punctuation} if punctuation else {}),
            "gloss": gloss,
            "analysis": {"kind": token_kind(word), "fields": {"meaning": gloss}},
        })
    token_ids = [token["id"] for token in tokens]
    return {
        "id": f"passage_{order}",
        "order": order,
        "title": title,
        "translation": translation,
        "phrases": [{
            "id": f"p{order}_ph1",
            "tokenIds": token_ids,
            "type": "Açıklama cümlesi",
            "meaning": translation,
        }],
        "tokens": tokens,
    }

def main():
    DATA.mkdir(parents=True, exist_ok=True)
    sections = []
    section_map = {}
    for offset, (section_id, section_title, title, arabic, translation) in enumerate(ENTRIES, 18):
        path = DATA / f"passage_{offset}.json"
        path.write_text(
            json.dumps(make_passage(offset, title, arabic, translation), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        if section_id not in section_map:
            section_map[section_id] = {
                "id": section_id,
                "order": 10 + len(sections),
                "title": section_title,
                "passages": [],
            }
            sections.append(section_map[section_id])
        section_map[section_id]["passages"].append(f"assets/data/ibare/bina/passage_{offset}.json")

    book = json.loads(BOOK.read_text(encoding="utf-8"))
    book["sections"] = [section for section in book["sections"] if section["order"] <= 9] + sections
    BOOK.write_text(json.dumps(book, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Generated {len(ENTRIES)} passages; total: {17 + len(ENTRIES)}")

if __name__ == "__main__":
    main()
