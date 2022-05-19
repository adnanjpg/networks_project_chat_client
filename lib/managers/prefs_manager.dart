import 'package:networks_project_chat_client/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/prefs_consts.dart';

abstract class PrefsManager {
  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString(userIdPrefs);
  }

  static Future<String?> getUserName() async {
    final prefs = await _prefs;
    return prefs.getString(userNamePrefs);
  }

  static Future<UserModel?> getUser() async {
    final userId = await getUserId();
    final userName = await getUserName();

    if (userId == null || userName == null) {
      return null;
    }

    return UserModel(
      id: userId,
      name: userName,
    );
  }

  static Future<void> setUser(UserModel user) async {
    final prefs = await _prefs;
    if (user.id != null) {
      await prefs.setString(userIdPrefs, user.id!.toString());
    }
    if (user.name != null) {
      await prefs.setString(userNamePrefs, user.name!.toString());
    }
  }
}
