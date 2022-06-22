import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:safe_button/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier{

  Locale _locale;

  LocaleProvider(this._locale);

  Locale get locale => _locale;

  void setLocale(Locale value) {
    if(!L10n.all.contains(locale)) return;
    _locale = value;
    notifyListeners();
  }

  void clearLocale(){
    _locale = const Locale('he');
    notifyListeners();
  }


}