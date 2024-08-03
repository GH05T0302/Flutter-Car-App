import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/vehicleProvider.dart';

class VehicleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return vehicleProvider.vehicles.isEmpty
                ? Center(
                    child: Text('No vehicles added'),
                  )
                : ListView.builder(
                    itemCount: vehicleProvider.vehicles.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('${vehicleProvider.vehicles[index].make} ${vehicleProvider.vehicles[index].model}'),
                          subtitle: Text('Year: ${vehicleProvider.vehicles[index].year}, Mileage: ${vehicleProvider.vehicles[index].mileage}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showEditVehicleDialog(context, vehicleProvider, index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteVehicleDialog(context, vehicleProvider, index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
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
                  Provider.of<VehicleProvider>(context, listen: false).addVehicle(
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

  void _showEditVehicleDialog(BuildContext context, VehicleProvider vehicleProvider, int index) {
    final _formKey = GlobalKey<FormState>();
    String? _make = vehicleProvider.vehicles[index].make;
    String? _model = vehicleProvider.vehicles[index].model;
    String? _year = vehicleProvider.vehicles[index].year.toString();
    String? _mileage = vehicleProvider.vehicles[index].mileage.toString();

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
                  vehicleProvider.updateVehicle(
                    index,
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
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteVehicleDialog(BuildContext context, VehicleProvider vehicleProvider, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Vehicle'),
          content: Text('Are you sure you want to delete this vehicle?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                vehicleProvider.removeVehicle(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
