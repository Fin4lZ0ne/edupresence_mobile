import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import http_parser package
import '../../data/url_api.dart';
import 'package:edupresence_mobile/core/utils/constant.dart';

class ImageUploadService {
  Future<Map<String, dynamic>> uploadImageWithLocation(
      Uint8List imageBytes, double latitude, double longitude) async {
    final url = Uri.parse(urlApi.sendAttempt());
    String? token = await Constant.getToken();

    // Debugging: Print the token
    print('Token: $token');

    // Membuat request multipart untuk mengirimkan gambar
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..fields['latitude'] = latitude.toString()
      ..fields['longitude'] = longitude.toString();

    // Menambahkan file gambar ke request
    final multipartFile = http.MultipartFile.fromBytes('image', imageBytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg')); // Correct MediaType

    request.files.add(multipartFile);

    // Debugging: print request details
    print('Request Headers: ${request.headers}');
    print('Request Fields: ${request.fields}');
    print(
        'Request Files: ${request.files.first.field} - ${request.files.first.filename}');

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);
      final data = jsonDecode(responseBody.body);

      // Debugging: print response details
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${responseBody.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['meta']['message'],
        };
      } else if (response.statusCode == 401) {
        // Handle unauthorized error
        return {
          'success': false,
          'message': 'Unauthorized: ${data['meta']['message']}',
        };
      } else {
        return {
          'success': false,
          'message': data['meta']['message'],
        };
      }
    } catch (error) {
      print('Error: $error');
      return {
        'success': false,
        'message': 'Failed to upload image.',
      };
    }
  }
}
