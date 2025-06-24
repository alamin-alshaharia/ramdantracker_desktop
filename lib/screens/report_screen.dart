import 'package:flutter/material.dart';
import 'app_error_widget.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: theme.colorScheme.primary, size: 32),
                const SizedBox(width: 12),
                Text('Reports & Analytics', style: theme.textTheme.headlineLarge),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 700),
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
                    Text('Prayer Completion', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),
                    // Sample progress bars for each prayer
                    _ProgressBar(label: 'Fajr', value: 0.9, color: const Color(0xFF16BC88)),
                    const SizedBox(height: 12),
                    _ProgressBar(label: 'Dhuhr', value: 0.8, color: const Color(0xFF14A87A)),
                    const SizedBox(height: 12),
                    _ProgressBar(label: 'Asr', value: 0.7, color: const Color(0xFF4A90E2)),
                    const SizedBox(height: 12),
                    _ProgressBar(label: 'Maghrib', value: 0.95, color: const Color(0xFFFFBE0B)),
                    const SizedBox(height: 12),
                    _ProgressBar(label: 'Isha', value: 0.85, color: const Color(0xFF16BC88)),
                    const SizedBox(height: 32),
                    // Ramadan progress
                    Text('Ramadan Progress', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),
                    _RamadanProgressBar(day: 10, totalDays: 30),
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

class _ProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _ProgressBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            minHeight: 14,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        Text('${(value * 100).toInt()}%'),
      ],
    );
  }
}

class _RamadanProgressBar extends StatelessWidget {
  final int day;
  final int totalDays;
  const _RamadanProgressBar({required this.day, required this.totalDays});

  @override
  Widget build(BuildContext context) {
    final percent = day / totalDays;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Day $day of $totalDays'),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percent,
          minHeight: 18,
          backgroundColor: const Color(0xFF16BC88).withOpacity(0.13),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF16BC88)),
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 8),
        Text('${(percent * 100).toStringAsFixed(1)}% completed'),
      ],
    );
  }
} 