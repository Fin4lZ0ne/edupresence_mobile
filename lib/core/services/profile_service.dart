import 'dart:convert';
import 'package:edupresence_mobile/core/models/user.dart';
import 'package:edupresence_mobile/core/utils/constant.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static Future<User> fetchUser() async {
    final url = Uri.parse('${Constant.baseUrl}/user');
    String? token = await Constant.getToken();
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
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final userData = jsonResponse['data'] as Map<String, dynamic>;
        return User.fromJson(userData);
      } catch (e) {
        print('Failed to decode user response: $e');
        throw 'Failed to decode user response';
      }
    } else {
      final errorResult = jsonDecode(response.body);
      print('Fetch user error response: $errorResult');
      throw '${errorResult['message'] ?? 'Unknown error occurred'}';
    }
  }
}
