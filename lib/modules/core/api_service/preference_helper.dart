import 'package:shared_preferences/shared_preferences.dart';

/// It's a wrapper around SharedPreferences that caches the values in memory
/// A class that is used to store the preferences of the user.
class PreferenceHelper {
  static const String userData = 'user_data';
  static const String userLanguage = 'en';
  static const String userToken = 'token';
  static const String hasReadAboutUs = 'is_accept_about_us';
  static const String hasReadGuidelines = 'is_accept_guidelines';
  static const String fcmToken = 'fcmToken';
  // static const String userHaveReadAboutUs = 'validate_about_us';
  // static const String userHaveReadGuidelines = 'validate_guidelines';

  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryPrefs = <String, dynamic>{};

  /// It loads the shared preferences.
  static Future<SharedPreferences> load() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// If the key is null, throw an exception, otherwise, set the value of the key to the value.
  ///
  /// Args:
  ///   key (String): The key to store the value under.
  ///   value (String): The value to be stored.
  static void setString(String key, String value) {
    _prefs!.setString(key, value);
    _memoryPrefs[key]= value;
  }

  /// Set the value of the key to the value.
  ///
  /// Args:
  ///   key (String): The key to store the value under.
  ///   value (int): The value to be stored.
  static void setInt(String key, int value) {
    _prefs!.setInt(key, value);
    _memoryPrefs[key] = value;
  }

  /// If the value is null, remove the key from the shared preferences, otherwise set the value.
  ///
  /// Args:
  ///   key (String): The key to store the value under.
  ///   value (double): The value to be stored.
  static void setDouble(String key, double value) {
    _prefs!.setDouble(key, value);
    _memoryPrefs[key] = value;
  }

  /// If the key is not null, then set the value of the key to the value of the value.
  ///
  /// Args:
  ///   key (String): The key to store the value under.
  ///   value (bool): The value to be stored.
  static void setBool(String key, bool value) {
    _prefs!.setBool(key, value);
    _memoryPrefs[key] = value;
  }

  /// If the key is not found, return the default value, otherwise return the value associated with the
  /// key.
  ///
  /// Args:
  ///   key (String): The key to look up.
  ///   def (String): The default value to return if the key is not found.
  static String? getString(String key, {String? def}) {
    String? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs!.getString(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val;
  }

  /// If the key is not found, return the default value, otherwise return the value as an integer.
  ///
  /// Args:
  ///   key (String): The key to look up.
  ///   def (int): The default value to return if the key is not found.
  static int getInt(String key, {int? def}) {
    int? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs!.getInt(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val!;
  }

  /// If the value is a double, return it, otherwise return the default value.
  ///
  /// Args:
  ///   key (String): The key to look up.
  ///   def (double): The default value to return if the key is not found.
  static double getDouble(String key, {double? def}) {
    double? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs!.getDouble(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val!;
  }

  /// "If the key exists in the
  /// preferences, return the value, otherwise return the default value."
  ///
  /// Args:
  ///   key (String): The key to get the value from.
  ///   def (bool): The default value to return if the key is not found. Defaults to false
  static bool getBool(String key, {bool def = false}) {
    bool? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs!.getBool(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val;
  }

  /// It clears the screen
  static void clear() {
    _memoryPrefs.remove(userData);
    _memoryPrefs.remove(userToken);
    // _memoryPrefs.remove(userHaveReadGuidelines);
    // _memoryPrefs.remove(userHaveReadAboutUs);
    _prefs!.remove(userData);
    _prefs!.remove(userToken);
    // _prefs!.remove(userHaveReadAboutUs);
    // _prefs!.remove(userHaveReadGuidelines);
  }
}
