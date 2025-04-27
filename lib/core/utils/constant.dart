import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  static const String baseUrl = 'https://apsensi.my.id/api';

  static Future<void> saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
     return preferences.getString('token');
  }
}