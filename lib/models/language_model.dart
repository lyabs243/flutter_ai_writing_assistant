class LanguageModel {

  final String name;
  final String code;

  LanguageModel({required this.name, required this.code});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LanguageModel && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  static List<LanguageModel> getSupportedLanguages() {
    return [
      LanguageModel(code: 'en', name: '🇺🇸 English'),
      LanguageModel(code: 'fr', name: '🇫🇷 Français'),
      LanguageModel(code: 'sw', name: '🇰🇪 Kiswahili'),
      LanguageModel(code: 'li', name: '🇨🇩 Lingala'),
      LanguageModel(code: 'hi', name: '🇮🇳 हिन्दी'),
    ];
  }

}