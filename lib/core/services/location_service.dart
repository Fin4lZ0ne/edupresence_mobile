import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/url_api.dart';
import 'package:edupresence_mobile/core/utils/constant.dart';


class LocationService {
  Future<bool> sendLocation(double latitude, double longitude) async {
    final url = Uri.parse(urlApi.sendLocation());
    String? token = await Constant.getToken();
    print('Fetch location token: $token');

    // Buat objek Request untuk mencetak detail permintaan
    final request = http.Request('POST', url)
      ..headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode(<String, String>{
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      });

    // // Cetak detail permintaan
    // print('Request URL: $url');
    // print('Request Headers: ${request.headers}');
    // print('Request Body: ${request.body}');

    // Kirim permintaan dan terima respon
    final response = await http.Response.fromStream(await request.send());

    // Cetak detail respon
    // print('Response Code: ${response.statusCode}');
    // print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['data']['isValid'];
    } else {
      return false;
    }
  }
}
