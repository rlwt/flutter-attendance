import 'package:flutter_attendance/constants/shared_preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences sharedPreferences;
  SharedPreferencesService(this.sharedPreferences);

  Future<bool> setEmail(String value) async {
    return sharedPreferences.setString(
        SharedPreferencesConstants.prefEmail, value);
  }

  String getEmail() {
    return sharedPreferences.getString(SharedPreferencesConstants.prefEmail) ??
        "";
  }

  Future<bool> clear() async {
    return sharedPreferences.clear();
  }
}
