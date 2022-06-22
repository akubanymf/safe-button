

import 'dart:ui';

class L10n {
  static final all = [
    const Locale('he'),
    const Locale('ar')
  ];

  static String getFlag(String code){
    switch (code) {
      case 'ar':
        return '🇦🇪';
      case 'he':
      default:
        // return '🇭🇪';
        return '🇮🇱';
    }
  }
}