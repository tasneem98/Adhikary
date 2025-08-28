import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceServices {
  // Keys
  static const String _enableNotificationKey = 'enable_notification_key';

  static String get enableNotification => _enableNotificationKey;

  // Shared Preference Singleton
  static final SharedPreferenceServices _instance =
      SharedPreferenceServices._internal();

  factory SharedPreferenceServices() => _instance;

  SharedPreferenceServices._internal();

  // Shared Preferences Setters and Getters

  Future<void> setBool({required String key, required bool value}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getBool(key) ?? false;
  }
}
