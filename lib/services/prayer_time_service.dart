import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service for fetching daily prayer times from the API.
///
/// Example usage:
/// ```dart
/// final service = PrayerTimeService('https://api.example.com');
/// final times = await service.fetchPrayerTimes(lat: 24.7136, lng: 46.6753, method: '2', madhab: '1');
/// ```
class PrayerTimeService {
  final String baseUrl;
  PrayerTimeService(this.baseUrl);

  Future<Map<String, dynamic>> fetchPrayerTimes({
    required double lat,
    required double lng,
    required String method,
    required String madhab,
  }) async {
    final url = Uri.parse('$baseUrl/prayer-times?lat=$lat&lng=$lng&method=$method&madhab=$madhab');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Cache the result
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('prayer_times_cache', response.body);
        return data;
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      // Try to return cached data if available
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('prayer_times_cache');
      if (cached != null) {
        return json.decode(cached);
      }
      rethrow;
    }
  }
} 