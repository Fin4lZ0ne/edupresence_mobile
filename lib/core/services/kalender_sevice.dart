import 'dart:convert';
import 'package:edupresence_mobile/core/models/calendar/calendar_model.dart';
import 'package:http/http.dart' as http;
import 'package:edupresence_mobile/core/utils/constant.dart';

class CalendarService {
  static Future<List<GetHolidays>> fetchHolidays(int month, int year) async {
    final url = Uri.parse('${Constant.baseUrl}/holidays?month=$month&year=$year');
    String? token = await Constant.getToken();
    print('Fetch holidays token: $token');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Fetch holidays response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final List<dynamic> holidaysData = jsonDecode(response.body);
        return holidaysData.map((holiday) => GetHolidays.fromJson(holiday)).toList();
      } catch (e) {
        print('Failed to decode holidays response: $e');
        throw 'Failed to decode holidays response';
      }
    } else {
      final errorResult = jsonDecode(response.body);
      print('Fetch holidays error response: $errorResult');
      throw '${errorResult['message'] ?? 'Unknown error occurred'}';
    }
  }

  static List<GetHolidays> filterHolidaysByMonth(List<GetHolidays> holidays, DateTime date) {
    return holidays.where((holiday) =>
      holiday.dateStart.year == date.year &&
      holiday.dateStart.month == date.month).toList();
  }
}
