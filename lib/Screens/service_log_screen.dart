import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/providers/service_provider.dart';
import 'package:ggt_assignment/providers/vehicleProvider.dart';
import 'package:intl/intl.dart';

class ServiceLogScreen extends StatefulWidget {
  @override
  _ServiceLogScreenState createState() => _ServiceLogScreenState();
}

class _ServiceLogScreenState extends State<ServiceLogScreen> {
  String? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    await vehicleProvider.fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Log'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<VehicleProvider>(
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
          ),
          Expanded(
            child: Consumer<ServiceProvider>(
              builder: (context, provider, child) {
                final logs = provider.serviceLogs.where((log) => log.vehicle == _selectedVehicle).toList();
                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return ListTile(
                      title: Text(log.task),
                      subtitle: Text(
                        'Completed: ${DateFormat('yyyy-MM-dd').format(log.completedDate)} - Mileage: ${log.mileage}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
