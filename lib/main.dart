// main.dart
import 'package:flutter/material.dart';
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
  runApp(const RamadanTrackerDesktopApp());
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
  ];

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
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
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
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
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: _buildPage(_selectedIndex),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ramadan Mubarak!', style: theme.textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'Welcome to Ramadan Tracker Desktop. Your spiritual companion for Ramadan.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          // Example cards for main features
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _FeatureCard(
                title: 'Prayer Times',
                icon: Icons.access_time,
                color: const Color(0xFF16BC88),
                onTap: () {},
              ),
              _FeatureCard(
                title: 'Hijri Calendar',
                icon: Icons.calendar_month,
                color: const Color(0xFF14A87A),
                onTap: () {},
              ),
              _FeatureCard(
                title: 'Quran Reader',
                icon: Icons.menu_book,
                color: const Color(0xFF4A90E2),
                onTap: () {},
              ),
              _FeatureCard(
                title: 'Hadith Collection',
                icon: Icons.library_books,
                color: const Color(0xFFFFBE0B),
                onTap: () {},
              ),
              _FeatureCard(
                title: 'Zakat Calculator',
                icon: Icons.calculate,
                color: const Color(0xFF16BC88),
                onTap: () {},
              ),
              _FeatureCard(
                title: 'Qibla Finder',
                icon: Icons.explore,
                color: const Color(0xFF14A87A),
                onTap: () {},
              ),
              _FeatureCard(
                title: 'Tasks & Checklist',
                icon: Icons.check_circle,
                color: const Color(0xFF4A90E2),
                onTap: () {},
              ),
              _FeatureCard(
                title: 'Videos & Recipes',
                icon: Icons.ondemand_video,
                color: const Color(0xFFFFBE0B),
                onTap: () {},
              ),
              _FeatureCard(
                title: 'Settings',
                icon: Icons.settings,
                color: const Color(0xFF16BC88),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), color.withOpacity(0.65)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              title,
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
    );
  }
}