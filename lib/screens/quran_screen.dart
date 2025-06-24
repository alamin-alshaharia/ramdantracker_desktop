import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quran_provider.dart';
import '../services/quran_service.dart';
import 'dart:ui';
import 'app_error_widget.dart';

class QuranScreen extends ConsumerWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final quran = ref.watch(quranProvider);
    final notifier = ref.read(quranProvider.notifier);
    final surahList = quran.surahList.isNotEmpty ? quran.surahList : ['Al-Fatiha'];
    final juzList = quran.juzList.isNotEmpty ? quran.juzList : ['Juz 1'];
    final surahIndex = surahList.indexOf(quran.currentSurah);
    final isFirstSurah = surahIndex <= 0;
    final isLastSurah = surahIndex >= surahList.length - 1;
    final surahMeta = surahList.isNotEmpty && surahIndex >= 0 && surahIndex < surahList.length
        ? 'Ayahs: 7  •  Revelation: Meccan'
        : '';
    Widget mainContent;
    if (quran.isLoading) {
      mainContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 60),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('Loading Surah...')),
          const SizedBox(height: 60),
        ],
      );
    } else if (quran.error != null) {
      mainContent = AppErrorWidget(
        message: 'Failed to load Quran data.',
        details: quran.error,
        onRetry: () {
          notifier.fetchSurahList();
          notifier.fetchSurah(quran.currentSurah);
        },
      );
    } else {
      mainContent = Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Surah/Juz navigation and metadata
                    Row(
                      children: [
                        MouseRegion(
                          cursor: isFirstSurah ? SystemMouseCursors.basic : SystemMouseCursors.click,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            color: isFirstSurah ? Colors.grey[400] : theme.colorScheme.primary,
                            onPressed: isFirstSurah
                                ? null
                                : () => notifier.setSurah(surahList[surahIndex - 1]),
                            tooltip: 'Previous Surah',
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: quran.currentSurah,
                          items: surahList
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => notifier.setSurah(v!),
                          borderRadius: BorderRadius.circular(16),
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          cursor: isLastSurah ? SystemMouseCursors.basic : SystemMouseCursors.click,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            color: isLastSurah ? Colors.grey[400] : theme.colorScheme.primary,
                            onPressed: isLastSurah
                                ? null
                                : () => notifier.setSurah(surahList[surahIndex + 1]),
                            tooltip: 'Next Surah',
                          ),
                        ),
                        const SizedBox(width: 24),
                        DropdownButton<String>(
                          value: quran.currentJuz,
                          items: juzList
                              .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                              .toList(),
                          onChanged: (v) => notifier.setJuz(v!),
                          borderRadius: BorderRadius.circular(16),
                          style: theme.textTheme.titleLarge,
                        ),
                        const Spacer(),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: IconButton(
                            icon: Icon(
                              quran.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: quran.isPlaying
                                  ? const Color(0xFF16BC88)
                                  : const Color(0xFFFFBE0B),
                              size: 36,
                            ),
                            tooltip: quran.isPlaying ? 'Pause Audio' : 'Play Audio',
                            onPressed: () {
                              notifier.toggleAudio();
                              final surahIdx = surahList.indexOf(quran.currentSurah) + 1;
                              final audioUrl = QuranService.audioBaseUrlSurah + '$surahIdx.mp3';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Audio URL: $audioUrl')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          surahMeta,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        quran.currentSurah,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Amiri',
                          color: Color(0xFF1F2937),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Show Translation', style: theme.textTheme.bodyMedium),
                              Switch(
                                value: quran.showTranslation,
                                onChanged: (_) => notifier.toggleShowTranslation(),
                                activeColor: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._buildAyahWidgets(quran, theme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth < 700 ? 8 : 32,
              vertical: constraints.maxWidth < 700 ? 8 : 32,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book, color: theme.colorScheme.primary, size: 36),
                      const SizedBox(width: 12),
                      Text('Quran Reader', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: SizedBox(
                          width: 220,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Surah or Juz',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: IconButton(
                          icon: Icon(
                            quran.bookmarks.contains(quran.currentSurah)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: const Color(0xFF4A90E2),
                          ),
                          tooltip: 'Toggle Bookmark',
                          onPressed: () {
                            if (quran.bookmarks.contains(quran.currentSurah)) {
                              notifier.removeBookmark(quran.currentSurah);
                            } else {
                              notifier.addBookmark(quran.currentSurah);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  mainContent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAyahWidgets(QuranState quran, ThemeData theme) {
    // Split Arabic and translation by ayah (assuming \u06dd or similar separator, fallback to period)
    final arabicAyahs = quran.arabicText.split(RegExp(r'\u06dd|\n|\r|\.|\u06da|\u06e0|\u06e1|\u06e2|\u06e3|\u06e4|\u06e5|\u06e6|\u06e7|\u06e8|\u06e9|\u06ea|\u06eb|\u06ec|\u06ed|\u06ee|\u06ef|\u06f0|\u06f1|\u06f2|\u06f3|\u06f4|\u06f5|\u06f6|\u06f7|\u06f8|\u06f9|\u06fa|\u06fb|\u06fc|\u06fd|\u06fe|\u06ff|\d+\s*'));
    final translationAyahs = quran.translation.split(RegExp(r'(?<=\.)\s+'));
    final count = arabicAyahs.length;
    return List.generate(count, (i) {
      final arabic = arabicAyahs[i].trim();
      final translation = i < translationAyahs.length ? translationAyahs[i].trim() : '';
      if (arabic.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Ayah ${i + 1}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              arabic,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                color: Color(0xFF1F2937),
              ),
            ),
            if (quran.showTranslation && translation.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                translation,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
} 