import 'package:flutter/material.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final times = [
      {'name': 'Fajr', 'time': '04:32 AM'},
      {'name': 'Dhuhr', 'time': '12:18 PM'},
      {'name': 'Asr', 'time': '03:45 PM'},
      {'name': 'Maghrib', 'time': '06:29 PM'},
      {'name': 'Isha', 'time': '07:55 PM'},
    ];
    final nextPrayerIndex = 1; // Example: Dhuhr is next

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: theme.colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Text('Prayer Times', style: theme.textTheme.headlineLarge),
              const Spacer(),
              // Location placeholder
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF14A87A)),
                    const SizedBox(width: 6),
                    Text('Your City', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Calculation method placeholder
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.settings, color: Color(0xFF16BC88)),
                    const SizedBox(width: 6),
                    Text('ISNA', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Notifications placeholder
              IconButton(
                icon: const Icon(Icons.notifications_active, color: Color(0xFFFFBE0B)),
                tooltip: 'Prayer Notifications',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Today', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      Text('Monday, 10 Ramadan 1445', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      for (int i = 0; i < times.length; i++)
                        TableRow(
                          decoration: BoxDecoration(
                            color: i == nextPrayerIndex
                                ? theme.colorScheme.primary.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: i == nextPrayerIndex
                                ? BorderRadius.circular(12)
                                : BorderRadius.zero,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    i == nextPrayerIndex ? Icons.arrow_forward : Icons.circle,
                                    color: i == nextPrayerIndex
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.secondary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    times[i]['name']!,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: i == nextPrayerIndex ? FontWeight.bold : FontWeight.normal,
                                      color: i == nextPrayerIndex
                                          ? theme.colorScheme.primary
                                          : theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                              child: Text(
                                times[i]['time']!,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: i == nextPrayerIndex ? FontWeight.bold : FontWeight.normal,
                                  color: i == nextPrayerIndex
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyLarge?.color,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                        const Icon(Icons.arrow_upward, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Next: ${times[nextPrayerIndex]['name']} at ${times[nextPrayerIndex]['time']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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