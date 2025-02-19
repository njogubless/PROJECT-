
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const String rememberMeKey = 'remember_me';
  static const String savedEmailKey = 'saved_email';
  static const String savedPasswordKey = 'saved_password';

  static Future<void> saveLoginCredentials(String email, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(rememberMeKey, rememberMe);
    if (rememberMe) {
      await prefs.setString(savedEmailKey, email);
      await prefs.setString(savedPasswordKey, password);
    } else {
      await prefs.remove(savedEmailKey);
      await prefs.remove(savedPasswordKey);
    }
  }

  static Future<Map<String, dynamic>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'rememberMe': prefs.getBool(rememberMeKey) ?? false,
      'email': prefs.getString(savedEmailKey) ?? '',
      'password': prefs.getString(savedPasswordKey) ?? '',
    };
  }
}