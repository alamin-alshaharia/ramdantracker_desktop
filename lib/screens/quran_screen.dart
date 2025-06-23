import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: theme.colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Text('Quran Reader', style: theme.textTheme.headlineLarge),
              const Spacer(),
              // Search placeholder
              SizedBox(
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
              const SizedBox(width: 16),
              // Bookmarks placeholder
              IconButton(
                icon: const Icon(Icons.bookmark, color: Color(0xFF4A90E2)),
                tooltip: 'Bookmarks',
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Surah/Juz navigation placeholder
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: 'Al-Fatiha',
                          items: const [
                            DropdownMenuItem(value: 'Al-Fatiha', child: Text('Al-Fatiha')),
                            DropdownMenuItem(value: 'Al-Baqarah', child: Text('Al-Baqarah')),
                          ],
                          onChanged: (v) {},
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: 'Juz 1',
                          items: const [
                            DropdownMenuItem(value: 'Juz 1', child: Text('Juz 1')),
                            DropdownMenuItem(value: 'Juz 2', child: Text('Juz 2')),
                          ],
                          onChanged: (v) {},
                        ),
                        const Spacer(),
                        // Audio controls placeholder
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: Color(0xFFFFBE0B), size: 32),
                          tooltip: 'Play Audio',
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.pause_circle_filled, color: Color(0xFF16BC88), size: 32),
                          tooltip: 'Pause Audio',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Quran text area (sample)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Text(
                              'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Amiri',
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'In the name of Allah, the Most Gracious, the Most Merciful.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 