import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import 'app_error_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    if (settings.error != null) {
      return AppErrorWidget(
        message: 'Failed to load settings.',
        details: settings.error,
        onRetry: notifier.reload,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Settings panel
                Expanded(
                  flex: 2,
                  child: Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.settings, color: theme.colorScheme.primary, size: 32),
                            const SizedBox(width: 12),
                            Text('Settings', style: theme.textTheme.headlineLarge),
                          ],
                        ),
                        const SizedBox(height: 32),
                        DropdownButtonFormField<String>(
                          value: settings.language,
                          decoration: const InputDecoration(
                            labelText: 'Language',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'English', child: Text('English')),
                            DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
                            DropdownMenuItem(value: 'Urdu', child: Text('Urdu')),
                          ],
                          onChanged: (v) => notifier.setLanguage(v!),
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          value: settings.madhab,
                          decoration: const InputDecoration(
                            labelText: 'Madhab',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Hanafi', child: Text('Hanafi')),
                            DropdownMenuItem(value: 'Shafi', child: Text('Shafi')),
                          ],
                          onChanged: (v) => notifier.setMadhab(v!),
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          value: settings.calculationMethod,
                          decoration: const InputDecoration(
                            labelText: 'Calculation Method',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'ISNA', child: Text('ISNA')),
                            DropdownMenuItem(value: 'MWL', child: Text('MWL')),
                            DropdownMenuItem(value: 'Umm al-Qura', child: Text('Umm al-Qura')),
                          ],
                          onChanged: (v) => notifier.setCalculationMethod(v!),
                        ),
                        const SizedBox(height: 18),
                        SwitchListTile(
                          value: settings.notificationsEnabled,
                          onChanged: notifier.setNotificationsEnabled,
                          title: const Text('Enable Notifications'),
                          activeColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SwitchListTile(
                          value: settings.darkMode,
                          onChanged: notifier.setDarkMode,
                          title: const Text('Dark Mode'),
                          activeColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                // About panel
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.info_outline, color: Color(0xFF14A87A), size: 32),
                        SizedBox(height: 12),
                        Text('About Ramadan Tracker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(height: 16),
                        Text(
                          'Ramadan Tracker helps you stay organized and spiritually focused during Ramadan. Track prayers, Quran, tasks, and more in a beautiful, modern desktop experience.',
                          style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                        ),
                        SizedBox(height: 24),
                        Text('Version 1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('© 2024 Ramadan Tracker Team'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 