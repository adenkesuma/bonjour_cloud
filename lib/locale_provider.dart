import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleProvider with ChangeNotifier{

  Locale locale = Locale('en');
  void changeLanguage(Locale newloc) {
    locale = newloc;
    Get.updateLocale(locale);
    notifyListeners();
  }
}
