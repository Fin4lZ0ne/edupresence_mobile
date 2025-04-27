import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edupresence_mobile/core/utils/constant.dart';
import '../../data/url_api.dart';

class GetStatusService {
  Future<Map<String, dynamic>> getStatus() async {
    final url = Uri.parse(urlApi.getStatus());
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
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load status');
    }
  }
}
