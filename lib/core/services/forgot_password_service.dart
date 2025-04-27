import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/url_api.dart';

class ForgotPasswordService {
  static Future<Map<String, dynamic>> requestOTP(String username) async {
    final response = await http.post(
      Uri.parse(urlApi.forgotPassword()),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to request OTP');
    }

    return jsonDecode(response.body);
  }

  static Future<void> verifyOTP(String username, String code) async {
    final response = await http.post(
      Uri.parse(urlApi.codeOTP()),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username, 'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP');
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      String username, String otp, String newPassword) async {
    final response = await http.post(
      Uri.parse(urlApi.resetPassword()),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {'username': username, 'code': otp, 'password': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password');
    }

    return jsonDecode(response.body);
  }
}
