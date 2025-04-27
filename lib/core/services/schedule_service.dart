import 'dart:convert';
import 'package:edupresence_mobile/core/models/jadwal/schedule.dart';
import 'package:edupresence_mobile/core/utils/constant.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  static Future <List<Schedule>> fetchSchedulesForDate(String date) async {
  final url = Uri.parse('${Constant.baseUrl}/schedules?date=$date');
  String? token = await Constant.getToken();
  print('Fetch schedules token: $token');
  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
    print('Fetch schedules response body: ${response.body}');

  if (response.statusCode == 200) {
    try {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> schedulesData = jsonResponse['data'];
      return schedulesData.map((schedule) => Schedule.fromJson(schedule)).toList();

    } catch (e) {
      print('Failed to decode get schedules response: $e');
      throw 'Failed to decode get schedules response';
    }
  } else {
    final errorResult = jsonDecode(response.body);
    print('Get schedules error response: $errorResult');
    throw '${errorResult['message'] ?? 'Unknown error occurred'}';
  }
}
}

