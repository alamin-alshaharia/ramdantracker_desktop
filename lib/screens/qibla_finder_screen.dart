import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/qibla_provider.dart';
import 'app_error_widget.dart';

class QiblaFinderScreen extends ConsumerWidget {
  const QiblaFinderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final qibla = ref.watch(qiblaProvider);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.explore, color: theme.colorScheme.primary, size: 32),
                const SizedBox(width: 12),
                Text('Qibla Finder', style: theme.textTheme.headlineLarge),
                const Spacer(),
                // Location
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
                      Text(qibla.location, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Refresh button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => ref.read(qiblaProvider.notifier).refresh(),
                  tooltip: 'Refresh location and compass',
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (qibla.isLoading) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading Qibla direction...'),
                  ],
                ),
              ),
            ] else if (qibla.error != null) ...[
              AppErrorWidget(
                message: 'Failed to load Qibla direction.',
                details: qibla.error,
                onRetry: () => ref.read(qiblaProvider.notifier).refresh(),
              ),
            ] else ...[
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Compass
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Compass background
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF16BC88),
                                  width: 2,
                                ),
                              ),
                            ),
                            // Compass markings
                            for (var i = 0; i < 360; i += 30)
                              Transform.rotate(
                                angle: i * math.pi / 180,
                                child: Align(
                                  alignment: const Alignment(0, -0.9),
                                  child: Container(
                                    width: 2,
                                    height: i % 90 == 0 ? 20 : 10,
                                    color: i % 90 == 0 
                                      ? const Color(0xFF16BC88)
                                      : Colors.grey[300],
                                  ),
                                ),
                              ),
                            // Cardinal directions
                            for (final Map<String, dynamic> entry in const [
                              {'text': 'N', 'angle': 0.0},
                              {'text': 'E', 'angle': 90.0},
                              {'text': 'S', 'angle': 180.0},
                              {'text': 'W', 'angle': 270.0},
                            ])
                              Transform.rotate(
                                angle: (entry['angle'] as double) * math.pi / 180,
                                child: Align(
                                  alignment: const Alignment(0, -0.7),
                                  child: Transform.rotate(
                                    angle: -(entry['angle'] as double) * math.pi / 180,
                                    child: Text(
                                      entry['text'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF16BC88),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            // Qibla direction arrow
                            if (qibla.compassHeading != null)
                              Transform.rotate(
                                angle: ((qibla.direction - qibla.compassHeading!) * math.pi / 180),
                                child: CustomPaint(
                                  size: const Size(240, 240),
                                  painter: QiblaArrowPainter(),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Direction indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.navigation, color: Color(0xFF4A90E2)),
                          const SizedBox(width: 8),
                          Text(
                            'Qibla Direction: ${qibla.direction.toStringAsFixed(1)}°',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      if (qibla.compassHeading != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Compass Heading: ${qibla.compassHeading!.toStringAsFixed(1)}°',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      // Feedback
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline, color: Color(0xFFFFBE0B)),
                            const SizedBox(width: 8),
                            Text(
                              qibla.feedback,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class QiblaArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF16BC88)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)  // Top center
      ..lineTo(size.width / 2 + 15, size.height / 2 - 30)  // Right point
      ..lineTo(size.width / 2 + 5, size.height / 2 - 30)   // Right inner
      ..lineTo(size.width / 2 + 5, size.height / 2)        // Bottom right
      ..lineTo(size.width / 2 - 5, size.height / 2)        // Bottom left
      ..lineTo(size.width / 2 - 5, size.height / 2 - 30)   // Left inner
      ..lineTo(size.width / 2 - 15, size.height / 2 - 30)  // Left point
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 