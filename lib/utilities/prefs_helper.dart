import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _nameKey = 'user_name';
    static const String _levelKey = 'user_level';
  static const String _purposeKey = 'user_purpose';
  static const String _fromCountryKey = 'user_fromCountry';
  static const String _toCountryKey = 'user_toCountry';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setName(String name) async {
    await _prefs?.setString(_nameKey, name);
  }

  static String? getName() {
    return _prefs?.getString(_nameKey);
  }

  static Future<void> setIsGenerated(bool isGenerated) async {
    await _prefs?.setBool('isGenerated', isGenerated);
  }
  static bool? getIsGenerated() {
    return _prefs?.getBool('isGenerated');
  }
}
