import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task_model.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = '/add-task';
  final bool isEdit;
  final String? taskId;

  AddTaskScreen({this.isEdit = false, this.taskId});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  DateTime _date = DateTime.now();
  int _mileage = 0;
  bool _isMileageBased = false;

  @override
  void didChangeDependencies() {
    if (widget.isEdit) {
      final task = Provider.of<TaskProvider>(context, listen: false).findById(widget.taskId!);
      _name = task.name;
      _description = task.description;
      _date = task.date;
      _mileage = task.mileage;
      _isMileageBased = task.isMileageBased;
    }
    super.didChangeDependencies();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.isEdit) {
        final updatedTask = MaintenanceTask(
          id: widget.taskId!,
          name: _name,
          description: _description,
          date: _date,
          mileage: _mileage,
          isMileageBased: _isMileageBased,
        );
        Provider.of<TaskProvider>(context, listen: false).updateTask(widget.taskId!, updatedTask);
      } else {
        final newTask = MaintenanceTask(
          id: Uuid().v4(),
          name: _name,
          description: _description,
          date: _date,
          mileage: _mileage,
          isMileageBased: _isMileageBased,
        );
        print("Saving task: $_name"); // Debugging line
        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SwitchListTile(
                title: Text('Mileage Based'),
                value: _isMileageBased,
                onChanged: (value) {
                  setState(() {
                    _isMileageBased = value;
                  });
                },
              ),
              if (_isMileageBased)
                TextFormField(
                  initialValue: _mileage > 0 ? _mileage.toString() : '',
                  decoration: InputDecoration(labelText: 'Mileage (km)'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _mileage = int.parse(value!);
                  },
                ),
              if (!_isMileageBased)
                TextFormField(
                  initialValue: _date.toIso8601String(),
                  decoration: InputDecoration(labelText: 'Date'),
                  keyboardType: TextInputType.datetime,
                  onSaved: (value) {
                    _date = DateTime.parse(value!);
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.isEdit ? 'Update Task' : 'Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
