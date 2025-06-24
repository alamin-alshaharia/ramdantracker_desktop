import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hadith_provider.dart';
import '../services/hadith_service.dart';
import 'dart:ui';
import 'app_error_widget.dart';

class HadithScreen extends ConsumerWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hadithState = ref.watch(hadithProvider);
    final notifier = ref.read(hadithProvider.notifier);
    final bookList = HadithService.collections;
    final filteredHadiths = hadithState.hadithList
        .where((h) => hadithState.searchQuery.isEmpty || h.title.toLowerCase().contains(hadithState.searchQuery.toLowerCase()))
        .toList();
    final searchController = TextEditingController(text: hadithState.searchQuery);
    final isLoading = hadithState.hadithList.isEmpty && hadithState.searchQuery.isEmpty;
    bool showBookmarks = false;
    void openBookmarksModal() {
      showDialog(
        context: context,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Bookmarks', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  if (hadithState.bookmarks.isEmpty)
                    const Text('No bookmarks yet.'),
                  for (final b in hadithState.bookmarks)
                    ListTile(
                      title: Text(b),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          notifier.removeBookmark(b);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // Error handling
    if (hadithState.error != null) {
      return AppErrorWidget(
        message: 'Failed to load Hadith data.',
        details: hadithState.error,
        onRetry: notifier.reload,
      );
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.library_books, color: theme.colorScheme.primary, size: 36),
                  const SizedBox(width: 12),
                  Text('Hadith Collection', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  // Search
                  MouseRegion(
                    cursor: SystemMouseCursors.text,
                    child: SizedBox(
                      width: 220,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Hadith',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: hadithState.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    notifier.setSearchQuery('');
                                    searchController.clear();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: notifier.setSearchQuery,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bookmarks
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: Icon(
                        hadithState.bookmarks.isNotEmpty ? Icons.bookmark : Icons.bookmark_border,
                        color: const Color(0xFF4A90E2),
                      ),
                      tooltip: 'Bookmarks',
                      onPressed: openBookmarksModal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 500,
                child: Center(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Book selection
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: hadithState.currentBook,
                                      items: bookList
                                          .map((b) => DropdownMenuItem(
                                                value: b,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.menu_book, size: 18, color: theme.colorScheme.primary),
                                                    const SizedBox(width: 8),
                                                    Text(b[0].toUpperCase() + b.substring(1)),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (v) {
                                        if (v != null) {
                                          notifier.setBook(v);
                                          notifier.fetchHadithsByBook(v);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      style: theme.textTheme.titleLarge,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                // Audio controls
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: IconButton(
                                    icon: Icon(
                                      hadithState.isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_fill,
                                      color: hadithState.isPlaying
                                          ? const Color(0xFF16BC88)
                                          : const Color(0xFFFFBE0B),
                                      size: 36,
                                    ),
                                    tooltip: hadithState.isPlaying ? 'Pause Audio' : 'Play Audio',
                                    onPressed: notifier.toggleAudio,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Hadith list
                            if (isLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: ListView.separated(
                                    key: ValueKey(filteredHadiths.length),
                                    itemCount: filteredHadiths.length,
                                    separatorBuilder: (context, i) => const SizedBox(height: 18),
                                    itemBuilder: (context, i) => MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.secondary.withOpacity(0.09),
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.04),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '#${filteredHadiths[i].title}',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                          color: Color(0xFF1F2937),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: theme.colorScheme.primary.withOpacity(0.12),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          hadithState.currentBook[0].toUpperCase() + hadithState.currentBook.substring(1),
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                            color: Color(0xFF4A90E2),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    filteredHadiths[i].snippet,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF6B7280),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                hadithState.bookmarks.contains(filteredHadiths[i].title)
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                color: const Color(0xFF4A90E2),
                                              ),
                                              tooltip: 'Toggle Bookmark',
                                              onPressed: () {
                                                if (hadithState.bookmarks.contains(filteredHadiths[i].title)) {
                                                  notifier.removeBookmark(filteredHadiths[i].title);
                                                } else {
                                                  notifier.addBookmark(filteredHadiths[i].title);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 