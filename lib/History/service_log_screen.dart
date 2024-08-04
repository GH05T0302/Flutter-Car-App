import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/History/service_provider.dart';
import 'package:intl/intl.dart';

class ServiceLogScreen extends StatelessWidget {
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
      body: Consumer<ServiceProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.serviceLogs.length,
            itemBuilder: (context, index) {
              final log = provider.serviceLogs[index];
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
    );
  }
}
