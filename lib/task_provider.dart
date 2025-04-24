import 'package:flutter/material.dart';
import 'dart:math';
import 'task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  
  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  
  int get taskCount => _tasks.length;
  int get completedTaskCount => completedTasks.length;
  int get pendingTaskCount => pendingTasks.length;

  // Add some sample tasks for demonstration
  TaskProvider() {
    addTask('Task 1 for today');
    addTask('Task 2 for today');
    addTask('Task 3 for today');
  }

  void addTask(String title, {String? description}) {
    final task = Task(
      id: Random().nextInt(10000).toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTask(String id, {String? title, String? description}) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        title: title,
        description: description,
      );
      notifyListeners();
    }
  }
}
