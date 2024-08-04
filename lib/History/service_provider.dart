import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'service_log.dart';

class ServiceProvider with ChangeNotifier {
  final String userEmail;

  ServiceProvider(this.userEmail) {
    fetchServiceLogs();
  }

  List<ServiceLog> _serviceLogs = [];
  List<ServiceLog> get serviceLogs => _serviceLogs;

  Future<void> fetchServiceLogs() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('serviceLogs')
          .doc(userEmail)
          .collection('logs')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No service logs found for this user.');
      }

      _serviceLogs = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ServiceLog.fromMap(data);
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching service logs: $error');
    }
  }

  Future<void> addServiceLog(ServiceLog serviceLog) async {
    try {
      await FirebaseFirestore.instance
          .collection('serviceLogs')
          .doc(userEmail)
          .collection('logs')
          .add(serviceLog.toMap());

      _serviceLogs.add(serviceLog);
      notifyListeners();

      print('Service log added successfully');
    } catch (error) {
      print('Error adding service log: $error');
    }
  }
}
