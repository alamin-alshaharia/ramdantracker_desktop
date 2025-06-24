import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/prayer_time_service.dart';
import 'package:geolocator/geolocator.dart';

class PrayerTime {
  final String name;
  final String time;
  final bool isNext;
  PrayerTime({required this.name, required this.time, this.isNext = false});
}

enum PrayerTimesStatus { loading, loaded, error }

class PrayerTimesState {
  final List<PrayerTime> times;
  final PrayerTimesStatus status;
  final String? error;
  final double latitude;
  final double longitude;
  final String locationName;
  PrayerTimesState({
    required this.times,
    required this.status,
    this.error,
    this.latitude = 22.3596,
    this.longitude = 90.3296,
    this.locationName = 'Patuakhali',
  });

  PrayerTimesState copyWith({
    List<PrayerTime>? times,
    PrayerTimesStatus? status,
    String? error,
    double? latitude,
    double? longitude,
    String? locationName,
  }) {
    return PrayerTimesState(
      times: times ?? this.times,
      status: status ?? this.status,
      error: error,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
    );
  }
}

class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  PrayerTimesNotifier()
      : super(PrayerTimesState(
          times: [
            PrayerTime(name: 'Fajr', time: '04:32 AM'),
            PrayerTime(name: 'Dhuhr', time: '12:18 PM', isNext: true),
            PrayerTime(name: 'Asr', time: '03:45 PM'),
            PrayerTime(name: 'Maghrib', time: '06:29 PM'),
            PrayerTime(name: 'Isha', time: '07:55 PM'),
          ],
          status: PrayerTimesStatus.loading,
          latitude: 22.3596,
          longitude: 90.3296,
          locationName: 'Patuakhali',
        )) {
    fetchPrayerTimesForCurrentLocation();
  }

  Future<void> fetchPrayerTimes({double? lat, double? lng, String? locationName}) async {
    state = state.copyWith(status: PrayerTimesStatus.loading);
    try {
      final latitude = lat ?? state.latitude;
      final longitude = lng ?? state.longitude;
      final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];
        final List<PrayerTime> times = [
          PrayerTime(name: 'Fajr', time: timings['Fajr']),
          PrayerTime(name: 'Dhuhr', time: timings['Dhuhr']),
          PrayerTime(name: 'Asr', time: timings['Asr']),
          PrayerTime(name: 'Maghrib', time: timings['Maghrib']),
          PrayerTime(name: 'Isha', time: timings['Isha']),
        ];
        state = state.copyWith(times: times, status: PrayerTimesStatus.loaded, error: null, latitude: latitude, longitude: longitude, locationName: locationName ?? state.locationName);
      } else {
        state = state.copyWith(status: PrayerTimesStatus.error, error: 'Failed to fetch data');
      }
    } catch (e) {
      state = state.copyWith(status: PrayerTimesStatus.error, error: e.toString());
    }
  }

  Future<void> fetchPrayerTimesForCurrentLocation() async {
    state = state.copyWith(status: PrayerTimesStatus.loading);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Fallback to Patuakhali
        await fetchPrayerTimes(lat: 22.3596, lng: 90.3296, locationName: 'Patuakhali');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Fallback to Patuakhali
          await fetchPrayerTimes(lat: 22.3596, lng: 90.3296, locationName: 'Patuakhali');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Fallback to Patuakhali
        await fetchPrayerTimes(lat: 22.3596, lng: 90.3296, locationName: 'Patuakhali');
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      // Optionally, use reverse geocoding for city name
      await fetchPrayerTimes(lat: position.latitude, lng: position.longitude, locationName: 'Your Location');
      state = state.copyWith(latitude: position.latitude, longitude: position.longitude, locationName: 'Your Location');
    } catch (e) {
      // Fallback to Patuakhali
      await fetchPrayerTimes(lat: 22.3596, lng: 90.3296, locationName: 'Patuakhali');
    }
  }
}

final prayerTimeServiceProvider = Provider<PrayerTimeService>((ref) {
  // Replace with your actual API base URL
  return PrayerTimeService('https://api.example.com');
});

final prayerTimesProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(prayerTimeServiceProvider);
  return await service.fetchPrayerTimes(
    lat: params['lat'],
    lng: params['lng'],
    method: params['method'],
    madhab: params['madhab'],
  );
});

final prayerTimesNotifierProvider = StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>(
  (ref) => PrayerTimesNotifier(),
); 