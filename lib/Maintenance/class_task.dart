import 'package:flutter/material.dart';
import 'package:ggt_assignment/Maintenance/maintenance_task.dart';

class Task with ChangeNotifier {
  List<MaintenanceTask> _tasks = [];

  List<MaintenanceTask> get tasks => _tasks;

  void addTask(MaintenanceTask task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(MaintenanceTask updatedTask) {
    int index = _tasks.indexWhere((task) => task.taskID == updatedTask.taskID);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String taskID) {
    _tasks.removeWhere((task) => task.taskID == taskID);
    notifyListeners();
  }
}
