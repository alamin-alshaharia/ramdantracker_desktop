import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramdantracker_desktop/services/hadith_service.dart';

class Hadith {
  final String title;
  final String snippet;
  const Hadith({required this.title, required this.snippet});
}

class HadithState {
  final String currentBook;
  final List<Hadith> hadithList;
  final String searchQuery;
  final bool isPlaying;
  final List<String> bookmarks;
  final String? error;
  const HadithState({
    required this.currentBook,
    required this.hadithList,
    required this.searchQuery,
    required this.isPlaying,
    required this.bookmarks,
    this.error,
  });

  HadithState copyWith({
    String? currentBook,
    List<Hadith>? hadithList,
    String? searchQuery,
    bool? isPlaying,
    List<String>? bookmarks,
    String? error,
  }) {
    return HadithState(
      currentBook: currentBook ?? this.currentBook,
      hadithList: hadithList ?? this.hadithList,
      searchQuery: searchQuery ?? this.searchQuery,
      isPlaying: isPlaying ?? this.isPlaying,
      bookmarks: bookmarks ?? this.bookmarks,
      error: error,
    );
  }
}

class HadithNotifier extends StateNotifier<HadithState> {
  final HadithService _hadithService;
  String _lastBook = 'bukhari';
  HadithNotifier({HadithService? hadithService})
      : _hadithService = hadithService ?? HadithService(),
        super(HadithState(
          currentBook: 'bukhari',
          hadithList: const [],
          searchQuery: '',
          isPlaying: false,
          bookmarks: const [],
        )) {
    fetchHadithsByBook('bukhari');
  }

  Future<void> fetchHadithsByBook(String collection) async {
    _lastBook = collection;
    try {
      final hadithsRaw = await _hadithService.getHadithsByBook(collection);
      final hadithList = hadithsRaw.map<Hadith>((h) => Hadith(
        title: h['hadithnumber'].toString(),
        snippet: h['text'] ?? '',
      )).toList();
      state = state.copyWith(currentBook: collection, hadithList: hadithList, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> fetchHadithById(String collection, int hadithNumber) async {
    try {
      final h = await _hadithService.getHadithById(collection, hadithNumber);
      final hadith = Hadith(title: h['hadithnumber'].toString(), snippet: h['text'] ?? '');
      state = state.copyWith(hadithList: [hadith], error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void reload() {
    fetchHadithsByBook(_lastBook);
  }

  void setBook(String book) => state = state.copyWith(currentBook: book);
  void setSearchQuery(String query) => state = state.copyWith(searchQuery: query);
  void toggleAudio() => state = state.copyWith(isPlaying: !state.isPlaying);
  void addBookmark(String title) {
    if (!state.bookmarks.contains(title)) {
      state = state.copyWith(bookmarks: [...state.bookmarks, title]);
    }
  }
  void removeBookmark(String title) {
    state = state.copyWith(bookmarks: state.bookmarks.where((b) => b != title).toList());
  }
}

final hadithProvider = StateNotifierProvider<HadithNotifier, HadithState>(
  (ref) => HadithNotifier(),
); 