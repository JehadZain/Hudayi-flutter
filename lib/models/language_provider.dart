import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

import 'package:hudayi/l10n/l10n.dart';

class LanguageProvider with ChangeNotifier {
  Locale? _locale = Locale(WidgetsBinding.instance.platformDispatcher.locale.languageCode);
  //Locale? _locale = Locale("ar");
  Locale? get locale => _locale!;
  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = Locale('');
    notifyListeners();
  }
}

   String getCurrentLocaleCode() {
    // Try to get the app's current locale
    Locale? currentLocale = Get.locale;

    if (currentLocale != null) {
      // If the app's locale is set, return its language code
      return currentLocale.languageCode;
    } else {
      // If the app's locale is not set, try to get the device's locale
      Locale? deviceLocale = Get.deviceLocale;
      if (deviceLocale != null) {
        // If the device's locale is found, return its language code
        return deviceLocale.languageCode;
      }
    }

    // If neither the app's locale nor the device's locale can be determined,
    // return a default language code, for example, 'en' for English.
    return 'tr';
  }

String? getFontName(BuildContext context) {
  return getCurrentLocaleCode() == "tr" ? "Roboto" : "PNU";
}
