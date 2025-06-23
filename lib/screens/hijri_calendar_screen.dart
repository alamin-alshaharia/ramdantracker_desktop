import 'package:flutter/material.dart';

class HijriCalendarScreen extends StatelessWidget {
  const HijriCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final hijriMonth = 'Ramadan 1445';
    final today = DateTime.now().day;
    final daysInMonth = 30;
    final firstDayOffset = 1; // e.g., 1 = Monday

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, color: theme.colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Text('Hijri Calendar', style: theme.textTheme.headlineLarge),
              const Spacer(),
              // Month navigation
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Previous Month',
                onPressed: () {},
              ),
              Text(hijriMonth, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Next Month',
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
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
                children: [
                  // Current date card
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF16BC88), Color(0xFF14A87A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Today: 10 Ramadan 1445',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Calendar grid
                  Table(
                    border: TableBorder(horizontalInside: BorderSide(color: Colors.grey[200]!)),
                    children: [
                      TableRow(
                        children: [
                          for (final d in daysOfWeek)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text(
                                  d,
                                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                      ...List.generate(5, (week) {
                        return TableRow(
                          children: [
                            for (int day = 0; day < 7; day++)
                              Builder(
                                builder: (context) {
                                  int date = week * 7 + day - firstDayOffset + 2;
                                  if (date < 1 || date > daysInMonth) {
                                    return const SizedBox.shrink();
                                  }
                                  final isToday = date == today;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: isToday
                                            ? BoxDecoration(
                                                color: theme.colorScheme.primary,
                                                borderRadius: BorderRadius.circular(12),
                                              )
                                            : null,
                                        child: Center(
                                          child: Text(
                                            '$date',
                                            style: TextStyle(
                                              color: isToday ? Colors.white : theme.textTheme.bodyLarge?.color,
                                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Important dates placeholder
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.event, color: Color(0xFF14A87A)),
                        SizedBox(width: 8),
                        Text(
                          'Important Islamic dates will appear here.',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 