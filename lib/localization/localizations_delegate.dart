import 'package:get/get.dart';

import 'languages/language_ar.dart';
import 'languages/language_bn.dart';
import 'languages/language_de.dart';
import 'languages/language_en.dart';
import 'languages/language_es.dart';
import 'languages/language_fr.dart';
import 'languages/language_hi.dart';
import 'languages/language_id.dart';
import 'languages/language_it.dart';
import 'languages/language_ja.dart';
import 'languages/language_ko.dart';
import 'languages/language_pa.dart';
import 'languages/language_pt.dart';
import 'languages/language_ru.dart';
import 'languages/language_ta.dart';
import 'languages/language_te.dart';
import 'languages/language_tr.dart';
import 'languages/language_ur.dart';
import 'languages/language_vi.dart';
import 'languages/language_zh.dart';

class AppLanguages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": enUS,
        "zh_CN": zhCN,
        "ar_SA": arSA,
        "fr_FR": frFR,
        "de_DE": deDE,
        "hi_IN": hiIN,
        "ja_JP": jaJP,
        "pt_PT": ptPT,
        "ru_RU": ruRU,
        "es_ES": esES,
        "ur_PK": urPK,
        "vi_VN": viVN,
        "id_ID": idID,
        "bn_IN": bnIN,
        "ta_IN": taIN,
        "te_IN": teIN,
        "tr_TR": trTR,
        "ko_KR": koKR,
        "pa_IN": paIN,
        "it_IT": itIT,
      };
}

final List<LanguageModel> languages = [
  LanguageModel("🇺🇸", "English", 'en', 'US'),
  LanguageModel("🇨🇳", "Chinese", 'zh', 'CN'),
  LanguageModel("🇸🇦", "Arabic", 'ar', 'SA'),
  LanguageModel("🇫🇷", "French", 'fr', 'FR'),
  LanguageModel("🇩🇪", "Dutch", 'de', 'DE'),
  LanguageModel("🇮🇳", "Hindi", 'hi', 'IN'),
  LanguageModel("🇯🇵", "Japanese", 'ja', 'JP'),
  LanguageModel("🇵🇹", "Portuguese", 'pt', 'PT'),
  LanguageModel("🇷🇺", "Russian", 'ru', 'RU'),
  LanguageModel("🇪🇸", "Spanish", 'es', 'ES'),
  LanguageModel("🇵🇰", "Urdu", 'ur', 'PK'),
  LanguageModel("🇻🇳", "Vietnamese", 'vi', 'VN'),
  LanguageModel("🇮🇩", "Indonesian", 'id', 'ID'),
  LanguageModel("🇮🇳", "Bangla", 'bn', 'IN'),
  LanguageModel("🇮🇳", "Tamil", 'ta', 'IN'),
  LanguageModel("🇮🇳", "Telugu", 'te', 'IN'),
  LanguageModel("🇹🇷", "Turkish", 'tr', 'TR'),
  LanguageModel("🇰🇵", "Korean", 'ko', 'KR'),
  LanguageModel("🇮🇳", "Punjabi", 'pa', 'IN'),
  LanguageModel("🇮🇹", "Italian", 'it', 'IT'),
];

class LanguageModel {
  LanguageModel(
    this.symbol,
    this.language,
    this.languageCode,
    this.countryCode,
  );

  String language;
  String symbol;
  String countryCode;
  String languageCode;
}
