import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'maintenance_task.dart';
import 'package:ggt_assignment/History/service_provider.dart';
import 'package:ggt_assignment/History/service_log.dart';

class MaintenanceProvider with ChangeNotifier {
  final String userEmail;
  final ServiceProvider serviceProvider;

  MaintenanceProvider(this.userEmail, this.serviceProvider) {
    fetchTasks();
  }

  List<MaintenanceTask> _tasks = [];
  List<MaintenanceTask> get tasks => _tasks;

  Future<void> fetchTasks() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('maintenance')
          .doc(userEmail)
          .collection('userTasks')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No tasks found for this user.');
      }

      _tasks = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MaintenanceTask.fromMap(data);
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  Future<void> addTask(MaintenanceTask task) async {
    try {
      await FirebaseFirestore.instance
          .collection('maintenance')
          .doc(userEmail)
          .collection('userTasks')
          .add(task.toMap());

      _tasks.add(task);
      notifyListeners();

      print('Task added successfully');
    } catch (error) {
      print('Error adding task: $error');
    }
  }

  Future<void> updateTask(MaintenanceTask oldTask, MaintenanceTask newTask) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('maintenance')
          .doc(userEmail)
          .collection('userTasks')
          .where('taskID', isEqualTo: oldTask.taskID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        await FirebaseFirestore.instance
            .collection('maintenance')
            .doc(userEmail)
            .collection('userTasks')
            .doc(docId)
            .update(newTask.toMap());

        await fetchTasks(); // Refresh task list after update

        print('Task updated successfully');
      } else {
        print('No matching document found to update');
      }
    } catch (error) {
      print('Error updating task: $error');
    }
  }

  Future<void> completeTask(MaintenanceTask task) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('maintenance')
          .doc(userEmail)
          .collection('userTasks')
          .where('taskID', isEqualTo: task.taskID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        // Add to service log
        final serviceLog = ServiceLog(
          task: task.task,
          taskID: task.taskID,
          mileage: task.mileage,
          dueDate: task.dueDate,
          vehicle: task.vehicle,
          completedDate: DateTime.now(),
        );
        await serviceProvider.addServiceLog(serviceLog);

        // Remove from maintenance tasks
        await FirebaseFirestore.instance
            .collection('maintenance')
            .doc(userEmail)
            .collection('userTasks')
            .doc(docId)
            .delete();

        _tasks.remove(task);
        notifyListeners();

        print('Task marked as completed and moved to service log');
      } else {
        print('No matching document found to update');
      }
    } catch (error) {
      print('Error completing task: $error');
    }
  }

  Future<void> removeTask(String taskID) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('maintenance')
          .doc(userEmail)
          .collection('userTasks')
          .where('taskID', isEqualTo: taskID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;
        await FirebaseFirestore.instance
            .collection('maintenance')
            .doc(userEmail)
            .collection('userTasks')
            .doc(docId)
            .delete();

        _tasks.removeWhere((task) => task.taskID == taskID);
        notifyListeners();

        print('Task removed successfully');
      }
    } catch (error) {
      print('Error removing task: $error');
    }
  }
}
