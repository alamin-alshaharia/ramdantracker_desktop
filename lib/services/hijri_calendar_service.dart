import 'dart:convert';
import 'package:http/http.dart' as http;

class HijriCalendarService {
  static const String baseUrl = 'https://api.aladhan.com/v1';

  /// Fetches the Hijri calendar for a given month and year at a specific location.
  /// [month] and [year] are Gregorian values. [latitude] and [longitude] are required.
  Future<List<dynamic>> fetchHijriCalendar({
    required int month,
    required int year,
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse('$baseUrl/calendar?latitude=$latitude&longitude=$longitude&method=2&month=$month&year=$year');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load Hijri calendar');
    }
  }
} 