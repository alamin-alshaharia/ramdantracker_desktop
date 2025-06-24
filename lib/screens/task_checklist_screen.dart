import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import 'app_error_widget.dart';

class TaskChecklistScreen extends ConsumerWidget {
  const TaskChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tasks = ref.watch(taskProvider);
    final notifier = ref.read(taskProvider.notifier);
    final TextEditingController controller = TextEditingController();

    void showAddTaskDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Task title'),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                notifier.addTask(value.trim());
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  notifier.addTask(controller.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    }

    if (tasks.error != null) {
      return AppErrorWidget(
        message: 'Failed to load tasks.',
        details: tasks.error,
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
              children: [
                Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 32),
                const SizedBox(width: 12),
                Text('Task & Checklist', style: theme.textTheme.headlineLarge),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: showAddTaskDialog,
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
                    ...List.generate(tasks.tasks.length, (i) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: tasks.tasks[i].done
                                ? theme.colorScheme.primary.withOpacity(0.10)
                                : theme.colorScheme.secondary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: CheckboxListTile(
                            value: tasks.tasks[i].done,
                            onChanged: (_) => notifier.toggleTask(i),
                            title: Text(
                              tasks.tasks[i].title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: tasks.tasks[i].done
                                    ? theme.colorScheme.primary
                                    : theme.textTheme.bodyLarge?.color,
                                decoration: tasks.tasks[i].done
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
      ),
    );
  }
} 