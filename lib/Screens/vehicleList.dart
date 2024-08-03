import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/vehicleProvider.dart';
import 'package:ggt_assignment/Screens/dashboard.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
                ? const Center(
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
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditVehicleDialog(context, vehicleProvider, index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
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
    final formKey = GlobalKey<FormState>();
    String? make, model, year, mileage;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Vehicle'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Make'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter make';
                    }
                    return null;
                  },
                  onSaved: (value) => make = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Model'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter model';
                    }
                    return null;
                  },
                  onSaved: (value) => model = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Year'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter year';
                    }
                    return null;
                  },
                  onSaved: (value) => year = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Mileage'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter mileage';
                    }
                    return null;
                  },
                  onSaved: (value) => mileage = value,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Provider.of<VehicleProvider>(context, listen: false).addVehicle(
                    Vehicle(
                      make: make!,
                      model: model!,
                      year: int.parse(year!),
                      mileage: int.parse(mileage!),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditVehicleDialog(BuildContext context, VehicleProvider vehicleProvider, int index) {
    final formKey = GlobalKey<FormState>();
    String? make = vehicleProvider.vehicles[index].make;
    String? model = vehicleProvider.vehicles[index].model;
    String? year = vehicleProvider.vehicles[index].year.toString();
    String? mileage = vehicleProvider.vehicles[index].mileage.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Vehicle'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: make,
                  decoration: const InputDecoration(labelText: 'Make'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter make';
                    }
                    return null;
                  },
                  onSaved: (value) => make = value,
                ),
                TextFormField(
                  initialValue: model,
                  decoration: const InputDecoration(labelText: 'Model'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter model';
                    }
                    return null;
                  },
                  onSaved: (value) => model = value,
                ),
                TextFormField(
                  initialValue: year,
                  decoration: const InputDecoration(labelText: 'Year'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter year';
                    }
                    return null;
                  },
                  onSaved: (value) => year = value,
                ),
                TextFormField(
                  initialValue: mileage,
                  decoration: const InputDecoration(labelText: 'Mileage'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter mileage';
                    }
                    return null;
                  },
                  onSaved: (value) => mileage = value,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  vehicleProvider.updateVehicle(
                    index,
                    Vehicle(
                      make: make!,
                      model: model!,
                      year: int.parse(year!),
                      mileage: int.parse(mileage!),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
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
          title: const Text('Delete Vehicle'),
          content: const Text('Are you sure you want to delete this vehicle?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                vehicleProvider.removeVehicle(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
