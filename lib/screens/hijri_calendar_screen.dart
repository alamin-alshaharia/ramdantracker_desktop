import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hijri_calendar_provider.dart';
import 'app_error_widget.dart';

class HijriCalendarScreen extends ConsumerWidget {
  const HijriCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final calendar = ref.watch(hijriCalendarProvider);
    final notifier = ref.read(hijriCalendarProvider.notifier);
    final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    if (calendar.error != null) {
      return AppErrorWidget(
        message: 'Failed to load Hijri calendar.',
        details: calendar.error,
        onRetry: notifier.reload,
      );
    }
    if (calendar.daysInMonth == 0) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
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
                  onPressed: notifier.prevMonth,
                ),
                Text('${calendar.currentMonth} ${calendar.currentYear}', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Next Month',
                  onPressed: notifier.nextMonth,
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
                            'Today: ${calendar.today} ${calendar.currentMonth} ${calendar.currentYear}',
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
                                    int date = week * 7 + day - 1 + 2;
                                    if (date < 1 || date > calendar.daysInMonth) {
                                      return const SizedBox.shrink();
                                    }
                                    final isToday = date == calendar.today;
                                    final isImportant = calendar.importantDates.any((d) => d.day == date);
                                    final importantLabel = isImportant
                                        ? calendar.importantDates.firstWhere((d) => d.day == date).label
                                        : null;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () => notifier.selectToday(date),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
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
                                              if (isImportant)
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Icon(Icons.event, color: Color(0xFFFFBE0B), size: 16),
                                                ),
                                            ],
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
                    // Important dates
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.event, color: Color(0xFF14A87A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              calendar.importantDates.isEmpty
                                  ? 'No important dates this month.'
                                  : calendar.importantDates.map((d) => '${d.label} (${d.day})').join(' • '),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
} 