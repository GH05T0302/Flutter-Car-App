import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/model/maintenance_task.dart';
import 'package:ggt_assignment/providers/maintenance_provider.dart';
import 'package:ggt_assignment/providers/vehicleProvider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
  String? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _taskController.text = widget.task!.task;
      _mileageController.text = widget.task!.mileage.toString();
      _dueDate = DateTime(widget.task!.dueDate.year, widget.task!.dueDate.month, widget.task!.dueDate.day);
      _selectedVehicle = widget.task!.vehicle;
    }
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    await vehicleProvider.fetchVehicles();
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
        _dueDate = DateTime(picked.year, picked.month, picked.day);
      });
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedVehicle != null) {
      final task = MaintenanceTask(
        task: _taskController.text,
        taskID: widget.task?.taskID ?? Uuid().v4(),
        mileage: int.parse(_mileageController.text),
        dueDate: DateTime(_dueDate.year, _dueDate.month, _dueDate.day),
        vehicle: _selectedVehicle!,
        isCompleted: widget.task?.isCompleted ?? false,
      );

      final provider = Provider.of<MaintenanceProvider>(context, listen: false);

      if (widget.task == null) {
        provider.addTask(task);
      } else {
        provider.updateTask(widget.task!, task);
      }

      Navigator.of(context).pop();
    }
  }

  void _completeTask() {
    if (widget.task != null) {
      final provider = Provider.of<MaintenanceProvider>(context, listen: false);
      provider.completeTask(widget.task!);
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
              Consumer<VehicleProvider>(
                builder: (context, vehicleProvider, child) {
                  final vehicles = vehicleProvider.vehicles;
                  return DropdownButtonFormField<String>(
                    value: _selectedVehicle,
                    decoration: InputDecoration(labelText: 'Select Vehicle'),
                    items: vehicles.map((vehicle) {
                      return DropdownMenuItem<String>(
                        value: vehicle.model,
                        child: Text(vehicle.model),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicle = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a vehicle';
                      }
                      return null;
                    },
                  );
                },
              ),
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
              if (widget.task != null && !widget.task!.isCompleted)
                ElevatedButton(
                  onPressed: _completeTask,
                  child: Text('Mark as Completed'),
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
