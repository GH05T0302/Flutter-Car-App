import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/Maintenance/maintenance_provider.dart';
import 'package:ggt_assignment/Maintenance/add_edit_task_screen.dart';
import 'package:intl/intl.dart'; // Import the intl package

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Schedule'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<MaintenanceProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return ListTile(
                title: Text(task.task),
                subtitle: Text(
                  'Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)} - Mileage: ${task.mileage}',
                ), // Format the due date
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: provider,
                              child: AddEditTaskScreen(task: task),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        provider.removeTask(task.taskID);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: Provider.of<MaintenanceProvider>(context, listen: false),
                child: AddEditTaskScreen(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
