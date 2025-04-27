import 'dart:convert';
import 'package:edupresence_mobile/core/models/perizinan/perizinan.dart';
import 'package:edupresence_mobile/core/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class PerizinanService {
  Future<Map<String, dynamic>> pengajuan({
    required String type,
    required String description,
    required PlatformFile document,
    required String duration,
    required String date,
  }) async {
    var uri = Uri.parse('${Constant.baseUrl}/excuses');
    String? token = await Constant.getToken();

    print('Posting data:');
    print('Type: $type');
    print('Description: $description');
    print('Document: ${document.name}, path: ${document.path}, size: ${document.size}');
    print('Duration: $duration');
    print('Date: $date');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['type'] = type
      ..fields['description'] = description
      ..fields['duration'] = duration
      ..fields['date'] = date
      ..files.add(await http.MultipartFile.fromPath(
        'document',
        document.path!,
        filename: document.name,
      ));

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    print('Response status: ${response.statusCode}');
    print('Response body: $responseString');

    if (response.statusCode == 200) {
      return json.decode(responseString);
    } else {
      throw Exception('Failed to submit permission: ${response.reasonPhrase}');
    }
  }

  Future<List<Perizinan>> daftarIzin() async {
    var uri = Uri.parse('${Constant.baseUrl}/excuses');
    String? token = await Constant.getToken();

    var response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body)['data'];
      List<Perizinan> excuses = jsonList.map((json) => Perizinan.fromJson(json)).toList();
      return excuses;
    } else {
      throw Exception('Failed to load excuses: ${response.reasonPhrase}');
    }
  }
}
