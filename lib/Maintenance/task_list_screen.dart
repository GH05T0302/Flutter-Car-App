import 'package:flutter/material.dart';
import 'package:ggt_assignment/Screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'add_task_screen.dart';
import 'package:ggt_assignment/Screens/dashboard.dart'; // Import the Dashboard widget

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    print("Building TaskListScreen with ${taskProvider.tasks.length} tasks"); // Debugging line
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
        title: Text('Maintenance Schedule'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddTaskScreen.routeName);
            },
          ),
        ],
      ),
      body: taskProvider.tasks.isEmpty
          ? Center(
              child: Text('No tasks added yet!'),
            )
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (ctx, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text(task.isMileageBased
                      ? '${task.mileage} km'
                      : '${task.date.toLocal()}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      taskProvider.deleteTask(task.id);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => AddTaskScreen(
                        isEdit: true,
                        taskId: task.id,
                      ),
                    ));
                  },
                );
              },
            ),
    );
  }
}