
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserEmail = 'user_email';

  static Future<void> setLoggedIn(bool value, {String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);

    if (email != null) {
      await prefs.setString(_keyUserEmail, email);
      print('📁 SharedPrefs: Saved login state - loggedIn: $value, email: $email');
    } else {
      print('📁 SharedPrefs: Saved login state - loggedIn: $value');
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    print('📁 SharedPrefs: Check login state - $loggedIn');
    return loggedIn;
  }

  static Future<void> clearLogin() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }
}