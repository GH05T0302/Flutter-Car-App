import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/model/vehicle.dart';
import 'package:ggt_assignment/vehicleProvider.dart';

import '../Firebase_Auth/auth_provider.dart';

class VehicleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user; // Get the user from AuthProvider

    if (user == null) {
      return Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => VehicleProvider(user.email!),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Vehicle List'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showAddVehicleDialog(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<VehicleProvider>(
            builder: (context, vehicleProvider, child) {
              return FutureBuilder(
                future: vehicleProvider.fetchVehicles(), // Call fetchVehicles
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return vehicleProvider.vehicles.isEmpty
                        ? Center(child: Text('No vehicles added'))
                        : ListView.builder(
                            itemCount: vehicleProvider.vehicles.length,
                            itemBuilder: (context, index) {
                              final vehicle = vehicleProvider.vehicles[index];
                              return Card(
                                child: ListTile(
                                  title:
                                      Text('${vehicle.make} ${vehicle.model}'),
                                  subtitle: Text(
                                      'Year: ${vehicle.year}, Mileage: ${vehicle.mileage}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditVehicleDialog(
                                              context, vehicle);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          vehicleProvider
                                              .removeVehicle(vehicle);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  String? _make, _model, _year, _mileage;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Vehicle'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Make'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter make';
                  }
                  return null;
                },
                onSaved: (value) => _make = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter model';
                  }
                  return null;
                },
                onSaved: (value) => _model = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Year'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter year';
                  }
                  return null;
                },
                onSaved: (value) => _year = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mileage'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter mileage';
                  }
                  return null;
                },
                onSaved: (value) => _mileage = value,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                print('Make: $_make, Model: $_model, Year: $_year, Mileage: $_mileage'); // Debug statement
                Provider.of<VehicleProvider>(context, listen: false)
                    .addVehicle(
                  Vehicle(
                    make: _make!,
                    model: _model!,
                    year: int.parse(_year!),
                    mileage: int.parse(_mileage!),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}

  
  void _showEditVehicleDialog(BuildContext context, Vehicle vehicle) {
  final _formKey = GlobalKey<FormState>();
  String? _make = vehicle.make;
  String? _model = vehicle.model;
  String? _year = vehicle.year.toString();
  String? _mileage = vehicle.mileage.toString();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Vehicle'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _make,
                decoration: InputDecoration(labelText: 'Make'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter make';
                  }
                  return null;
                },
                onSaved: (value) => _make = value,
              ),
              TextFormField(
                initialValue: _model,
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter model';
                  }
                  return null;
                },
                onSaved: (value) => _model = value,
              ),
              TextFormField(
                initialValue: _year,
                decoration: InputDecoration(labelText: 'Year'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter year';
                  }
                  return null;
                },
                onSaved: (value) => _year = value,
              ),
              TextFormField(
                initialValue: _mileage,
                decoration: InputDecoration(labelText: 'Mileage'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter mileage';
                  }
                  return null;
                },
                onSaved: (value) => _mileage = value,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                print('Form saved with: make=$_make, model=$_model, year=$_year, mileage=$_mileage');
                
                final updatedVehicle = Vehicle(
                  make: _make!,
                  model: _model!,
                  year: int.parse(_year!),
                  mileage: int.parse(_mileage!),
                );

                // Call the updateVehicle function with old and new vehicle details
                Provider.of<VehicleProvider>(context, listen: false)
                    .updateVehicle(vehicle, updatedVehicle);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}



}
