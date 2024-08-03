import 'package:flutter/material.dart';
import 'package:ggt_assignment/Maintenance/maintenance_task.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 
import 'package:ggt_assignment/Maintenance/class_task.dart';
import 'package:uuid/uuid.dart'; // Import to generate unique IDs

class AddEditTaskScreen extends StatefulWidget {
  final MaintenanceTask? task;

  AddEditTaskScreen({this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _mileageController = TextEditingController();
  DateTime _dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _taskController.text = widget.task!.task;
      _mileageController.text = widget.task!.mileage.toString();
      _dueDate = widget.task!.dueDate;
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate)
      setState(() {
        _dueDate = picked;
      });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final task = MaintenanceTask(
        task: _taskController.text,
        taskID: widget.task?.taskID ?? Uuid().v4(),
        mileage: int.parse(_mileageController.text),
        dueDate: _dueDate,
      );

      final provider = Provider.of<Task>(context, listen: false);

      if (widget.task == null) {
        provider.addTask(task);
      } else {
        provider.updateTask(task);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _taskController,
                decoration: InputDecoration(labelText: 'Task'),
                                 validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Mileage (km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the mileage';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
                  TextButton(
                    onPressed: () => _selectDueDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    _mileageController.dispose();
    super.dispose();
  }
}

