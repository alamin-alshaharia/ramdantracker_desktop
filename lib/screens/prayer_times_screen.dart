import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/prayer_times_provider.dart';
import 'app_error_widget.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prayerTimesState = ref.watch(prayerTimesNotifierProvider);
    final notifier = ref.read(prayerTimesNotifierProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final isTablet = constraints.maxWidth >= 700 && constraints.maxWidth < 1200;
        final isDesktop = constraints.maxWidth >= 1200;
        final double pad = isMobile ? 8 : 32;
        final double headerFont = isMobile ? 22 : isTablet ? 28 : 38;
        final double cardPad = isMobile ? 12 : 32;

        if (prayerTimesState.status == PrayerTimesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (prayerTimesState.status == PrayerTimesStatus.error) {
          return AppErrorWidget(
            message: 'Failed to load prayer times.',
            details: prayerTimesState.error ?? '',
            onRetry: () => notifier.fetchPrayerTimes(),
          );
        }
        final times = prayerTimesState.times;
        final nextPrayerIndex = times.isNotEmpty ? 0 : -1;
        return Padding(
          padding: EdgeInsets.all(pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, color: theme.colorScheme.primary, size: isMobile ? 24 : 32),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text('Prayer Times', style: theme.textTheme.headlineLarge?.copyWith(fontSize: headerFont)),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: isMobile ? 4 : 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF14A87A)),
                        const SizedBox(width: 6),
                        Text(
                          '${prayerTimesState.locationName} (${prayerTimesState.latitude.toStringAsFixed(2)}, ${prayerTimesState.longitude.toStringAsFixed(2)})',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.my_location, color: Color(0xFF16BC88)),
                          tooltip: 'Detect Location',
                          onPressed: () => notifier.fetchPrayerTimesForCurrentLocation(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isMobile ? 8 : 16),
                  IconButton(
                    icon: const Icon(Icons.notifications_active, color: Color(0xFFFFBE0B)),
                    tooltip: 'Prayer Notifications',
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 32),
              Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: isMobile ? 400 : 600),
                  padding: EdgeInsets.all(cardPad),
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
                      SizedBox(height: isMobile ? 12 : 24),
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
                                  padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 14.0, horizontal: isMobile ? 4 : 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        i == nextPrayerIndex ? Icons.arrow_forward : Icons.circle,
                                        color: i == nextPrayerIndex
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.secondary,
                                        size: isMobile ? 14 : 18,
                                      ),
                                      SizedBox(width: isMobile ? 6 : 10),
                                      Text(
                                        times[i].name,
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
                                  padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 14.0, horizontal: isMobile ? 4 : 8),
                                  child: Text(
                                    times[i].time,
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
                      SizedBox(height: isMobile ? 12 : 24),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12, horizontal: isMobile ? 12 : 20),
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
                            SizedBox(width: isMobile ? 4 : 8),
                            Text(
                              nextPrayerIndex != -1
                                  ? 'Next: ${times[nextPrayerIndex].name} at ${times[nextPrayerIndex].time}'
                                  : 'All prayers completed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 13 : 16,
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
      },
    );
  }
} 