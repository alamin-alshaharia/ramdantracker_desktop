import 'package:flutter_riverpod/flutter_riverpod.dart';

class Task {
  final String title;
  final bool done;
  Task({required this.title, this.done = false});

  Task copyWith({String? title, bool? done}) {
    return Task(
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }
}

class TaskState {
  final List<Task> tasks;
  final String? error;
  const TaskState({required this.tasks, this.error});

  TaskState copyWith({List<Task>? tasks, String? error}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      error: error,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  TaskNotifier()
      : super(TaskState(tasks: [
          Task(title: 'Fajr Prayer', done: true),
          Task(title: 'Read Quran (1 Juz)'),
          Task(title: 'Give Charity'),
          Task(title: 'Attend Taraweeh'),
          Task(title: 'Make Dua', done: true),
        ]));

  void addTask(String title) {
    try {
      state = state.copyWith(tasks: [...state.tasks, Task(title: title)], error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void toggleTask(int index) {
    try {
      state = state.copyWith(
        tasks: [
          for (int i = 0; i < state.tasks.length; i++)
            if (i == index)
              state.tasks[i].copyWith(done: !state.tasks[i].done)
            else
              state.tasks[i]
        ],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void removeTask(int index) {
    try {
      state = state.copyWith(
        tasks: [
          for (int i = 0; i < state.tasks.length; i++)
            if (i != index) state.tasks[i]
        ],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> reload() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>(
  (ref) => TaskNotifier(),
); 