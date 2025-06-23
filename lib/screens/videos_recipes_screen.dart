import 'package:flutter/material.dart';

class VideosRecipesScreen extends StatelessWidget {
  const VideosRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videos = [
      {'title': 'Ramadan Reflections', 'category': 'Spiritual', 'thumb': Icons.play_circle_fill},
      {'title': 'Healthy Suhoor Ideas', 'category': 'Recipe', 'thumb': Icons.fastfood},
      {'title': 'Quran Recitation', 'category': 'Quran', 'thumb': Icons.menu_book},
      {'title': 'Iftar Recipes', 'category': 'Recipe', 'thumb': Icons.restaurant},
    ];
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.ondemand_video, color: theme.colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Text('Videos & Recipes', style: theme.textTheme.headlineLarge),
              const Spacer(),
              // Search placeholder
              SizedBox(
                width: 220,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search videos or recipes',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Filter placeholder
              DropdownButton<String>(
                value: 'All',
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All')),
                  DropdownMenuItem(value: 'Spiritual', child: Text('Spiritual')),
                  DropdownMenuItem(value: 'Recipe', child: Text('Recipe')),
                  DropdownMenuItem(value: 'Quran', child: Text('Quran')),
                ],
                onChanged: (v) {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Featured video placeholder
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.play_circle_fill, color: Color(0xFF16BC88), size: 48),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Featured: Ramadan Reflections', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 8),
                        Text('A special video to inspire your Ramadan journey.', style: TextStyle(color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Watch'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Grid/list of videos & recipes
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 2.8,
              ),
              itemCount: videos.length,
              itemBuilder: (context, i) {
                final v = videos[i];
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(v['thumb'] as IconData, color: theme.colorScheme.primary, size: 32),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(v['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                v['category'] as String,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF14A87A)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow, color: Color(0xFFFFBE0B)),
                        onPressed: () {},
                        tooltip: 'Play',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 