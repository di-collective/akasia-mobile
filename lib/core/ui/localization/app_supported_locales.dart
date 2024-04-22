enum AppSupportedLocales {
  en(languageCode: 'en', languageName: 'English');

  const AppSupportedLocales({required this.languageCode, required this.languageName});

  final String languageCode;
  final String languageName;
}
