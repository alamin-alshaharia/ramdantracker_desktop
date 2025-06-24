import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ramdantracker_desktop/services/quran_service.dart';

class QuranState {
  final String currentSurah;
  final String currentJuz;
  final String arabicText;
  final String translation;
  final bool isPlaying;
  final List<String> bookmarks;
  final bool isLoading;
  final String? error;
  final List<String> surahList;
  final List<String> juzList;
  final bool showTranslation;
  const QuranState({
    required this.currentSurah,
    required this.currentJuz,
    required this.arabicText,
    required this.translation,
    required this.isPlaying,
    required this.bookmarks,
    this.isLoading = false,
    this.error,
    this.surahList = const [],
    this.juzList = const [],
    this.showTranslation = true,
  });

  QuranState copyWith({
    String? currentSurah,
    String? currentJuz,
    String? arabicText,
    String? translation,
    bool? isPlaying,
    List<String>? bookmarks,
    bool? isLoading,
    String? error,
    List<String>? surahList,
    List<String>? juzList,
    bool? showTranslation,
  }) {
    return QuranState(
      currentSurah: currentSurah ?? this.currentSurah,
      currentJuz: currentJuz ?? this.currentJuz,
      arabicText: arabicText ?? this.arabicText,
      translation: translation ?? this.translation,
      isPlaying: isPlaying ?? this.isPlaying,
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      surahList: surahList ?? this.surahList ?? const [],
      juzList: juzList ?? this.juzList ?? const [],
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }
}

class QuranNotifier extends StateNotifier<QuranState> {
  final QuranService _quranService;
  QuranNotifier({QuranService? quranService})
      : _quranService = quranService ?? QuranService(),
        super(const QuranState(
          currentSurah: 'Al-Fatiha',
          currentJuz: 'Juz 1',
          arabicText: '',
          translation: '',
          isPlaying: false,
          bookmarks: [],
          isLoading: true,
          showTranslation: true,
        )) {
    fetchSurahList();
    fetchSurah('Al-Fatiha');
  }

  Future<void> fetchSurahList() async {
    try {
      final surahs = await _quranService.listSurahs();
      final surahNames = surahs.map<String>((s) => s['englishName'] as String).toList();
      final juzList = List.generate(30, (i) => 'Juz ${i + 1}');
      String newCurrentSurah = state.currentSurah;
      if (!surahNames.contains(newCurrentSurah)) {
        newCurrentSurah = surahNames.isNotEmpty ? surahNames.first : '';
      }
      state = state.copyWith(surahList: surahNames, juzList: juzList, currentSurah: newCurrentSurah);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> fetchSurah(String surahName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final surahs = await _quranService.listSurahs();
      final surah = surahs.firstWhere((s) => s['englishName'].toLowerCase() == surahName.toLowerCase(), orElse: () => null);
      if (surah == null) throw Exception('Surah not found');
      final surahNum = surah['number'];
      final surahData = await _quranService.getSurahWithTranslations(surahNum);
      final editions = surahData['data'] as List;
      final arabicEdition = editions.firstWhere((e) => e['edition']['identifier'] == 'quran-uthmani', orElse: () => null);
      final enEdition = editions.firstWhere((e) => e['edition']['identifier'] == 'en.asad', orElse: () => null);
      final arabicText = arabicEdition != null ? (arabicEdition['ayahs'] as List).map((a) => a['text']).join(' ') : '';
      final translation = enEdition != null ? (enEdition['ayahs'] as List).map((a) => a['text']).join(' ') : '';
      state = state.copyWith(
        currentSurah: surahName,
        arabicText: arabicText,
        translation: translation,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSurah(String surah) {
    fetchSurah(surah);
  }
  void setJuz(String juz) => state = state.copyWith(currentJuz: juz);
  void toggleAudio() => state = state.copyWith(isPlaying: !state.isPlaying);
  void addBookmark(String surah) {
    if (!state.bookmarks.contains(surah)) {
      state = state.copyWith(bookmarks: [...state.bookmarks, surah]);
    }
  }
  void removeBookmark(String surah) {
    state = state.copyWith(bookmarks: state.bookmarks.where((b) => b != surah).toList());
  }
  void toggleShowTranslation() {
    state = state.copyWith(showTranslation: !state.showTranslation);
  }
}

final quranProvider = StateNotifierProvider<QuranNotifier, QuranState>(
  (ref) => QuranNotifier(),
); 