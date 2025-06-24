import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/hijri_calendar_service.dart';
import 'package:geolocator/geolocator.dart';

class ImportantDate {
  final int day;
  final String label;
  const ImportantDate({required this.day, required this.label});
}

class HijriCalendarState {
  final String currentMonth;
  final int currentYear;
  final int daysInMonth;
  final int today;
  final List<ImportantDate> importantDates;
  final String? error;
  const HijriCalendarState({
    required this.currentMonth,
    required this.currentYear,
    required this.daysInMonth,
    required this.today,
    required this.importantDates,
    this.error,
  });

  HijriCalendarState copyWith({
    String? currentMonth,
    int? currentYear,
    int? daysInMonth,
    int? today,
    List<ImportantDate>? importantDates,
    String? error,
  }) {
    return HijriCalendarState(
      currentMonth: currentMonth ?? this.currentMonth,
      currentYear: currentYear ?? this.currentYear,
      daysInMonth: daysInMonth ?? this.daysInMonth,
      today: today ?? this.today,
      importantDates: importantDates ?? this.importantDates,
      error: error,
    );
  }
}

class HijriCalendarNotifier extends StateNotifier<HijriCalendarState> {
  final HijriCalendarService _service = HijriCalendarService();
  HijriCalendarNotifier()
      : super(const HijriCalendarState(
          currentMonth: 'Ramadan',
          currentYear: 1445,
          daysInMonth: 30,
          today: 10,
          importantDates: [
            ImportantDate(day: 1, label: 'Start of Ramadan'),
            ImportantDate(day: 27, label: 'Laylat al-Qadr'),
            ImportantDate(day: 30, label: 'Eid al-Fitr'),
          ],
        )) {
    fetchHijriCalendarForCurrentLocation();
  }

  Future<void> fetchHijriCalendarForCurrentLocation() async {
    try {
      double latitude = 22.3596;
      double longitude = 90.3296;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          final position = await Geolocator.getCurrentPosition();
          latitude = position.latitude;
          longitude = position.longitude;
        }
      }
      await fetchHijriCalendar(
        month: DateTime.now().month,
        year: DateTime.now().year,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> fetchHijriCalendar({
    required int month,
    required int year,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final data = await _service.fetchHijriCalendar(
        month: month,
        year: year,
        latitude: latitude,
        longitude: longitude,
      );
      // Parse the first day for today, and important dates for Ramadan
      final today = DateTime.now().day;
      final hijriMonth = data[0]['date']['hijri']['month']['en'];
      final hijriYear = int.parse(data[0]['date']['hijri']['year']);
      final daysInMonth = data.length;
      final List<ImportantDate> importantDates = [];
      for (final day in data) {
        final hijriDay = int.parse(day['date']['hijri']['day']);
        final holidays = day['date']['hijri']['holidays'] as List<dynamic>;
        for (final holiday in holidays) {
          importantDates.add(ImportantDate(day: hijriDay, label: holiday));
        }
      }
      state = state.copyWith(
        currentMonth: hijriMonth,
        currentYear: hijriYear,
        daysInMonth: daysInMonth,
        today: today,
        importantDates: importantDates,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> reload() async {
    await fetchHijriCalendarForCurrentLocation();
  }

  void nextMonth() async {
    final now = DateTime.now();
    int nextMonth = now.month + 1;
    int year = now.year;
    if (nextMonth > 12) {
      nextMonth = 1;
      year += 1;
    }
    await fetchHijriCalendar(
      month: nextMonth,
      year: year,
      latitude: 22.3596,
      longitude: 90.3296,
    );
  }

  void prevMonth() async {
    final now = DateTime.now();
    int prevMonth = now.month - 1;
    int year = now.year;
    if (prevMonth < 1) {
      prevMonth = 12;
      year -= 1;
    }
    await fetchHijriCalendar(
      month: prevMonth,
      year: year,
      latitude: 22.3596,
      longitude: 90.3296,
    );
  }

  void selectToday(int day) => state = state.copyWith(today: day, error: null);
}

final hijriCalendarProvider = StateNotifierProvider<HijriCalendarNotifier, HijriCalendarState>(
  (ref) => HijriCalendarNotifier(),
); 