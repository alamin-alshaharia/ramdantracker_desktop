import 'package:flutter/material.dart';

class TaskChecklistScreen extends StatelessWidget {
  const TaskChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasks = [
      {'title': 'Fajr Prayer', 'done': true},
      {'title': 'Read Quran (1 Juz)', 'done': false},
      {'title': 'Give Charity', 'done': false},
      {'title': 'Attend Taraweeh', 'done': false},
      {'title': 'Make Dua', 'done': true},
    ];
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Text('Task & Checklist', style: theme.textTheme.headlineLarge),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Today', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.calendar_month, color: Color(0xFF14A87A)),
                        tooltip: 'View Calendar',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...tasks.map((task) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: (task['done'] as bool)
                              ? theme.colorScheme.primary.withOpacity(0.10)
                              : theme.colorScheme.secondary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: CheckboxListTile(
                          value: task['done'] as bool?,
                          onChanged: (_) {},
                          title: Text(
                            task['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: (task['done'] as bool)
                                  ? theme.colorScheme.primary
                                  : theme.textTheme.bodyLarge?.color,
                              decoration: (task['done'] as bool)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 