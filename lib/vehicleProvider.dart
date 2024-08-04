import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/vehicle.dart';

class VehicleProvider with ChangeNotifier {

  final String userEmail;

  


  VehicleProvider(this.userEmail);

  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(userEmail)
        .collection('userVehicles')
        .get();

    // Check if documents are retrieved
    if (querySnapshot.docs.isEmpty) {
      print('No vehicles found for this user.');
    }

    // Map querySnapshot documents to Vehicle objects
    _vehicles = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Vehicle.fromMap(data);
    }).toList();

    notifyListeners(); // Notify listeners of data changes
  } catch (error) {
    print('Error fetching vehicles: $error');
  }
}

  Future<void> addVehicle(Vehicle vehicle) async {
  try {
    print('Adding vehicle: ${vehicle.toMap()}');
    
    await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(userEmail)
        .collection('userVehicles')
        .add(vehicle.toMap());

    // Add vehicle to the list and notify listeners
    _vehicles.add(vehicle);
    notifyListeners();
    
    print('Vehicle added successfully');
  } catch (error) {
    print('Error adding vehicle: $error');
  }
}


  Future<void> updateVehicle(Vehicle oldVehicle, Vehicle newVehicle) async {
  try {
    print('Attempting to update vehicle with the following criteria:');
    print('Old Make: ${oldVehicle.make}');
    print('Old Model: ${oldVehicle.model}');
    print('Old Year: ${oldVehicle.year}');
    print('Old Mileage: ${oldVehicle.mileage}');

    final querySnapshot = await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(userEmail)
        .collection('userVehicles')
        .where('make', isEqualTo: oldVehicle.make.trim())
        .where('mileage', isEqualTo: oldVehicle.mileage)
        .where('model', isEqualTo: oldVehicle.model.trim())
        .where('year', isEqualTo: oldVehicle.year)
        .get();

    print('Query snapshot: ${querySnapshot.docs.length} documents found');

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;
      print('Found document ID: $docId');
      
      final vehicleMap = newVehicle.toMap();
      print('Updating document with data: $vehicleMap');

      await FirebaseFirestore.instance
          .collection('vehicles')
          .doc(userEmail)
          .collection('userVehicles')
          .doc(docId)
          .update(vehicleMap);

      print('Vehicle updated successfully');

      // Refresh vehicle list after update
      await fetchVehicles();
    } else {
      print('No matching document found to update');
    }
  } catch (error) {
    print('Error updating vehicle: $error');
  }
}





  Future<void> removeVehicle(Vehicle vehicle) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('vehicles')
          .doc(userEmail)
          .collection('userVehicles')
          .where('make', isEqualTo: vehicle.make)
          .where('model', isEqualTo: vehicle.model)
          .where('year', isEqualTo: vehicle.year)
          .where('mileage', isEqualTo: vehicle.mileage)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;
        await FirebaseFirestore.instance
            .collection('vehicles')
            .doc(userEmail)
            .collection('userVehicles')
            .doc(docId)
            .delete();

        // Remove vehicle from the list and notify listeners
        _vehicles.remove(vehicle);
        notifyListeners();
      }
    } catch (error) {
      print('Error removing vehicle: $error');
    }
  }
  Future<void> debugFetchVehicles() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(userEmail)
        .collection('userVehicles')
        .get();

    print('Total documents found: ${querySnapshot.docs.length}');
    for (var doc in querySnapshot.docs) {
      print('Document ID: ${doc.id}, Data: ${doc.data()}');
    }
  } catch (error) {
    print('Error fetching vehicles: $error');
  }
}

}
