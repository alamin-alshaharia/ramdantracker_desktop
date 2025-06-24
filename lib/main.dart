// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// IMPORTANT: This code is specifically tailored for desktop_webview_window version ^0.6.1
// If your pubspec.yaml uses an older version, you MUST update it to ^0.6.1
// and run 'flutter pub get' for this code to work correctly.
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'dart:io' show Platform, exit;
// Note: path_provider is no longer strictly needed for userDataFolderWindows in ^0.6.1
// as getWebviewPaths() provides it directly. However, it doesn't hurt to keep it if used elsewhere.
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/prayer_times_screen.dart';
import 'screens/hijri_calendar_screen.dart';
import 'screens/quran_screen.dart';
import 'screens/hadith_screen.dart';
import 'screens/zakat_calculator_screen.dart';
import 'screens/task_checklist_screen.dart';
import 'screens/videos_recipes_screen.dart';
import 'screens/qibla_finder_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/report_screen.dart';


// This part is crucial for 'desktop_webview_window' to initialize correctly.
// It must be placed directly in your `main.dart` file.
// It handles the creation of the webview's title bar widget.
Future<void> main(List<String> args) async {
  // Ensure Flutter engine is initialized before any Flutter-specific calls.
  WidgetsFlutterBinding.ensureInitialized();

  // If the arguments indicate a webview title bar should be run, handle it and exit.
  // This is part of the package's internal mechanism to manage webview windows.
  if (runWebViewTitleBarWidget(args)) {
    return;
  }

  // Run your main Flutter application.
  runApp(const ProviderScope(child: RamadanTrackerDesktopApp()));
}

// The root widget of your Flutter application.
class RamadanTrackerDesktopApp extends StatelessWidget {
  const RamadanTrackerDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramadan Tracker Desktop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF16BC88),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF16BC88),
          secondary: const Color(0xFF14A87A),
          background: const Color(0xFFFAFAFA),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Color(0xFF1F2937),
          onSurface: Color(0xFF1F2937),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        cardColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Color(0xFF1F2937),
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Color(0xFF1F2937),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
        fontFamily: 'Amiri', // Fallback to default if not available
        useMaterial3: true,
      ),
      home: const DesktopShell(),
    );
  }
}

class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key});

  @override
  State<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<DesktopShell> {
  int _selectedIndex = 0;

  static const List<String> _navItems = [
    'Dashboard',
    'Prayer Times',
    'Hijri Calendar',
    'Quran',
    'Hadith',
    'Zakat',
    'Tasks',
    'Videos & Recipes',
    'Qibla Finder',
    'Settings',
    'Reports',
  ];

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPage(int index, BoxConstraints constraints) {
    switch (index) {
      case 0:
        return DashboardScreen(onNavigate: _navigateTo, constraints: constraints);
      case 1:
        return const PrayerTimesScreen();
      case 2:
        return const HijriCalendarScreen();
      case 3:
        return const QuranScreen();
      case 4:
        return const HadithScreen();
      case 5:
        return const ZakatCalculatorScreen();
      case 6:
        return const TaskChecklistScreen();
      case 7:
        return const QiblaFinderScreen();
      case 8:
        return const SettingsScreen();
      case 9:
        return const ReportScreen();
      default:
        return Center(
          child: Text(
            _navItems[index],
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                    ),
                    child: NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      backgroundColor: Colors.white,
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            // Placeholder for app logo/icon
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFF16BC88),
                              child: Icon(Icons.star, color: Colors.white, size: 32),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.dashboard),
                          label: Text('Dashboard'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.access_time),
                          label: Text('Prayer Times'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.calendar_month),
                          label: Text('Hijri Calendar'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.menu_book),
                          label: Text('Quran'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.library_books),
                          label: Text('Hadith'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.calculate),
                          label: Text('Zakat'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.check_circle),
                          label: Text('Tasks'),
                        ),
                        // NavigationRailDestination(
                        //   icon: Icon(Icons.ondemand_video),
                        //   label: Text('Videos & Recipes'),
                        // ),
                        NavigationRailDestination(
                          icon: Icon(Icons.explore),
                          label: Text('Qibla Finder'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings),
                          label: Text('Settings'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.bar_chart),
                          label: Text('Reports'),
                        ),
                      ],
                      selectedIconTheme: const IconThemeData(color: Color(0xFF16BC88), size: 28),
                      unselectedIconTheme: const IconThemeData(color: Color(0xFF6B7280), size: 24),
                      selectedLabelTextStyle: const TextStyle(
                        color: Color(0xFF16BC88),
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelTextStyle: const TextStyle(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  );
                },
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: _buildPage(_selectedIndex, constraints),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final void Function(int) onNavigate;
  final BoxConstraints constraints;
  const DashboardScreen({super.key, required this.onNavigate, required this.constraints});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.expand(
      child: Stack(
        children: [
          // Animated gradient background
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF16BC88), Color(0xFF14A87A), Color(0xFF4A90E2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Decorative blurred circles
          Positioned(
            top: 60,
            left: 80,
            child: _BlurCircle(size: 120, color: Colors.white.withOpacity(0.12)),
          ),
          Positioned(
            bottom: 80,
            right: 120,
            child: _BlurCircle(size: 90, color: Colors.white.withOpacity(0.10)),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Glassmorphism greeting card
                  Center(
                    child: Container(
                      width: 600,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 36),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text('Ramadan Mubarak!', style: theme.textTheme.headlineLarge?.copyWith(color: const Color(0xFF16BC88))),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome to Ramadan Tracker Desktop. Your spiritual companion for Ramadan.',
                            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Summary row (example: today's fasting info)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SummaryCard(
                          icon: Icons.wb_sunny,
                          label: 'Fasting Time',
                          value: '04:18 AM - 07:45 PM',
                          color: const Color(0xFFFFBE0B),
                        ),
                        const SizedBox(width: 32),
                        _SummaryCard(
                          icon: Icons.calendar_today,
                          label: 'Today',
                          value: '10 Ramadan 1445',
                          color: const Color(0xFF16BC88),
                        ),
                        const SizedBox(width: 32),
                        _SummaryCard(
                          icon: Icons.check_circle,
                          label: 'Prayers Completed',
                          value: '4/5',
                          color: const Color(0xFF4A90E2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Feature cards grid
                  Center(
                    child: Wrap(
                      spacing: 32,
                      runSpacing: 32,
                      children: [
                        _FeatureCardModern(
                          title: 'Prayer Times',
                          icon: Icons.access_time,
                          color: const Color(0xFF16BC88),
                          onTap: () => onNavigate(1),
                        ),
                        _FeatureCardModern(
                          title: 'Hijri Calendar',
                          icon: Icons.calendar_month,
                          color: const Color(0xFF14A87A),
                          onTap: () => onNavigate(2),
                        ),
                        _FeatureCardModern(
                          title: 'Quran Reader',
                          icon: Icons.menu_book,
                          color: const Color(0xFF4A90E2),
                          onTap: () => onNavigate(3),
                        ),
                        _FeatureCardModern(
                          title: 'Hadith Collection',
                          icon: Icons.library_books,
                          color: const Color(0xFFFFBE0B),
                          onTap: () => onNavigate(4),
                        ),
                        _FeatureCardModern(
                          title: 'Zakat Calculator',
                          icon: Icons.calculate,
                          color: const Color(0xFF16BC88),
                          onTap: () => onNavigate(5),
                        ),
                        _FeatureCardModern(
                          title: 'Qibla Finder',
                          icon: Icons.explore,
                          color: const Color(0xFF14A87A),
                          onTap: () => onNavigate(7),
                        ),
                        _FeatureCardModern(
                          title: 'Tasks & Checklist',
                          icon: Icons.check_circle,
                          color: const Color(0xFF4A90E2),
                          onTap: () => onNavigate(6),
                        ),
                        _FeatureCardModern(
                          title: 'Videos & Recipes',
                          icon: Icons.ondemand_video,
                          color: const Color(0xFFFFBE0B),
                          onTap: () => onNavigate(7),
                        ),
                        _FeatureCardModern(
                          title: 'Settings',
                          icon: Icons.settings,
                          color: const Color(0xFF16BC88),
                          onTap: () => onNavigate(8),
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

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _SummaryCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.13),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.18), width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        ],
      ),
    );
  }
}

class _FeatureCardModern extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _FeatureCardModern({required this.title, required this.icon, required this.color, required this.onTap, super.key});

  @override
  State<_FeatureCardModern> createState() => _FeatureCardModernState();
}

class _FeatureCardModernState extends State<_FeatureCardModern> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 220,
        height: 140,
        transform: _hovering ? _scaledMatrix() : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color.withOpacity(0.92), widget.color.withOpacity(0.72)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_hovering ? 0.22 : 0.13),
              blurRadius: _hovering ? 24 : 16,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: widget.color.withOpacity(_hovering ? 0.22 : 0.13),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: widget.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 48, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Matrix4 _scaledMatrix() {
    final matrix = Matrix4.identity();
    matrix.scale(1.045);
    return matrix;
  }
}