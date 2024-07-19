import 'package:flutter/material.dart';

enum AppLocale {
  en,
  id,
}

extension AppLocaleExtension on AppLocale {
  Locale get locale {
    switch (this) {
      case AppLocale.en:
        return const Locale('en', 'US');
      case AppLocale.id:
        return const Locale('id', 'ID');
    }
  }
}
