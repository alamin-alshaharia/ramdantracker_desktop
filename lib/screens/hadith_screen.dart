import 'package:flutter/material.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

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
              Icon(Icons.library_books, color: theme.colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Text('Hadith Collection', style: theme.textTheme.headlineLarge),
              const Spacer(),
              // Search placeholder
              SizedBox(
                width: 220,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Hadith',
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
                    // Book selection placeholder
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: 'Sahih Bukhari',
                          items: const [
                            DropdownMenuItem(value: 'Sahih Bukhari', child: Text('Sahih Bukhari')),
                            DropdownMenuItem(value: 'Sahih Muslim', child: Text('Sahih Muslim')),
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
                    // Hadith list (sample)
                    Expanded(
                      child: ListView.separated(
                        itemCount: 5,
                        separatorBuilder: (context, i) => const SizedBox(height: 16),
                        itemBuilder: (context, i) => Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Hadith Title Example',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '"Actions are but by intentions..."',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
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