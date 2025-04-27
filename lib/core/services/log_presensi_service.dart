import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:edupresence_mobile/core/utils/constant.dart';
import '../../data/url_api.dart';

class LogPresensiService {
  Future<List<Map<String, dynamic>>> getLogPresensi() async {
    final url = Uri.parse(urlApi.getLogPresensi());
    String? token = await Constant.getToken();
    print('Fetch status token: $token');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Fetch status response body: ${response.body}');
    if (response.statusCode == 200) {
      // Parse response body as List<Map<String, dynamic>>
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load status');
    }
  }
}
