import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings {
  final String language;
  final String madhab;
  final String calculationMethod;
  final bool notificationsEnabled;
  final bool darkMode;
  final String? error;
  const Settings({
    required this.language,
    required this.madhab,
    required this.calculationMethod,
    required this.notificationsEnabled,
    required this.darkMode,
    this.error,
  });

  Settings copyWith({
    String? language,
    String? madhab,
    String? calculationMethod,
    bool? notificationsEnabled,
    bool? darkMode,
    String? error,
  }) {
    return Settings(
      language: language ?? this.language,
      madhab: madhab ?? this.madhab,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      error: error,
    );
  }
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier()
      : super(const Settings(
          language: 'English',
          madhab: 'Hanafi',
          calculationMethod: 'ISNA',
          notificationsEnabled: true,
          darkMode: false,
        ));

  void setLanguage(String language) {
    try {
      state = state.copyWith(language: language, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  void setMadhab(String madhab) {
    try {
      state = state.copyWith(madhab: madhab, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  void setCalculationMethod(String method) {
    try {
      state = state.copyWith(calculationMethod: method, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  void setNotificationsEnabled(bool enabled) {
    try {
      state = state.copyWith(notificationsEnabled: enabled, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  void setDarkMode(bool enabled) {
    try {
      state = state.copyWith(darkMode: enabled, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  Future<void> reload() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
); 