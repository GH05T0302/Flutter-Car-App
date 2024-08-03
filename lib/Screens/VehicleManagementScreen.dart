import 'package:flutter/material.dart';

class Vehicle {
  String make;
  String model;
  int year;
  int mileage;

  Vehicle({
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
  });
}

class VehicleManagementScreen extends StatefulWidget {
  @override
  VehicleManagementScreenState createState() => VehicleManagementScreenState();
}

class VehicleManagementScreenState extends State<VehicleManagementScreen> {
  static List<Vehicle> vehicles = [];
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  int _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _makeController,
                    decoration: InputDecoration(
                      labelText: 'Make',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter make';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: 'Model',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter model';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _yearController,
                    decoration: InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter year';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _mileageController,
                    decoration: InputDecoration(
                      labelText: 'Mileage',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter mileage';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          if (_currentIndex == -1) {
                            vehicles.add(Vehicle(
                              make: _makeController.text,
                              model: _modelController.text,
                              year: int.parse(_yearController.text),
                              mileage: int.parse(_mileageController.text),
                            ));
                          } else {
                            vehicles[_currentIndex] = Vehicle(
                              make: _makeController.text,
                              model: _modelController.text,
                              year: int.parse(_yearController.text),
                              mileage: int.parse(_mileageController.text),
                            );
                            _currentIndex = -1;
                          }
                          _makeController.clear();
                          _modelController.clear();
                          _yearController.clear();
                          _mileageController.clear();
                        });
                      }
                    },
                    child: Text('Save Vehicle'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${vehicles[index].make} ${vehicles[index].model}'),
                      subtitle: Text('Year: ${vehicles[index].year}, Mileage: ${vehicles[index].mileage}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _makeController.text = vehicles[index].make;
                                _modelController.text = vehicles[index].model;
                                _yearController.text = vehicles[index].year.toString();
                                _mileageController.text = vehicles[index].mileage.toString();
                                _currentIndex = index;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                vehicles.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
