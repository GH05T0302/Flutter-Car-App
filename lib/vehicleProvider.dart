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

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void updateVehicle(int index, Vehicle vehicle) {
    _vehicles[index] = vehicle;
    notifyListeners();
  }

  void removeVehicle(int index) {
    _vehicles.removeAt(index);
    notifyListeners();
  }
}
