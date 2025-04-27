import 'dart:convert';
import 'package:edupresence_mobile/core/models/user.dart';
import 'package:edupresence_mobile/core/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> login(String username, String password) async {
    final url = Uri.parse('${Constant.baseUrl}/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      try {
        final result = jsonDecode(response.body);
        print('Login response: $result');

        final String token = result['data']['token'];
        await Constant.saveToken(token);
        print('Token saved: $token');
      } catch (e) {
        print('Failed to decode login response: $e');
      }
    } else {
      final errorResult = jsonDecode(response.body);
      print('Login error response: $errorResult');
      throw '${errorResult['meta']['message'] ?? 'Unknown error occurred'}';
    }
  }

  static Future<void> logout(SharedPreferences preferences) async {
    final url = Uri.parse('${Constant.baseUrl}/logout');
    String? token = await Constant.getToken();
    if (token != null) {
      await http.delete(url, headers: {'Authorization': 'Bearer $token'});
      await Constant.saveToken('');
    } else {
      throw 'Token tidak ditemukan';
    }
  }

  static Future<User?> fetchUserData(String token) async {
    final url = Uri.parse('${Constant.baseUrl}/user');
    print('Fetch user token: $token');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Fetch user response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final result = jsonDecode(response.body);
        return User.fromJson(result['data']);
      } catch (e) {
        print('Failed to decode get user response: $e');
        throw 'Failed to decode get user response';
      }
    } else {
      final errorResult = jsonDecode(response.body);
      print('Get user error response: $errorResult');
      throw '${errorResult['message'] ?? 'Unknown error occurred'}';
    }
  }
}
