import 'package:flutter/foundation.dart';
import 'task_model.dart';
import 'dart:collection';

class TaskProvider with ChangeNotifier {
  List<MaintenanceTask> _tasks = [];

  UnmodifiableListView<MaintenanceTask> get tasks => UnmodifiableListView(_tasks);

  void addTask(MaintenanceTask task) {
    _tasks.add(task);
    print("Task added: ${task.name}"); // Debugging line
    notifyListeners();
  }

  void updateTask(String id, MaintenanceTask updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index >= 0) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    print("Task deleted: $id"); // Debugging line
    notifyListeners();
  }

  MaintenanceTask findById(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }
}
