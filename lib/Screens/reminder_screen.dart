import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/providers/reminder_provider.dart';
import 'package:ggt_assignment/model/maintenance_task.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Reminders'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.reminders.length,
            itemBuilder: (context, index) {
              final task = provider.reminders[index];
              return ReminderTaskItem(task: task);
            },
          );
        },
      ),
    );
  }
}

class ReminderTaskItem extends StatelessWidget {
  final MaintenanceTask task;

  ReminderTaskItem({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReminderProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        title: Text(task.task),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)} - Mileage: ${task.mileage}'),
            Text('Model: ${task.vehicle}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.snooze),
              onPressed: () {
                // Snooze task by 7 days
                provider.snoozeReminder(task, Duration(days: 7));
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                provider.completeReminder(task);
              },
            ),
          ],
        ),
      ),
    );
  }
}
