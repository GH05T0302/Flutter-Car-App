import 'package:flutter/material.dart';
import 'package:ggt_assignment/Firebase_Auth/auth_provider.dart';
import 'package:ggt_assignment/Screens/login.dart';
import 'package:ggt_assignment/Screens/settingsScreen.dart';
import 'package:ggt_assignment/providers/themeProvider.dart';
import 'package:ggt_assignment/widgets/customTextStyle.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/Screens/task_list_screen.dart';
import 'package:ggt_assignment/Screens/vehicleList.dart';
import 'package:ggt_assignment/Screens/service_log_screen.dart';
import 'package:ggt_assignment/Screens/reminder_screen.dart';
import 'package:ggt_assignment/Screens/ProfileScreen.dart';
import 'package:ggt_assignment/providers/vehicleProvider.dart';
import 'package:ggt_assignment/providers/maintenance_provider.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final maintenanceProvider = Provider.of<MaintenanceProvider>(context);

    // Fetch vehicles and maintenance tasks for the current user
    if (authProvider.user != null) {
      vehicleProvider.fetchVehicles();
      maintenanceProvider.fetchTasks();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.account_circle),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Profile')),
              PopupMenuItem<int>(value: 1, child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              VehicleSummary(vehicleProvider: vehicleProvider),
              SizedBox(height: 20),
              UpcomingMaintenanceTasks(maintenanceProvider: maintenanceProvider),
              SizedBox(height: 20),
              QuickAccessFeatures(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingsScreen(),
          ),
        );
        break;
    }
  }
}

class VehicleSummary extends StatelessWidget {
  final VehicleProvider vehicleProvider;

  VehicleSummary({required this.vehicleProvider});

  @override
  Widget build(BuildContext context) {
    final textStyle = getCustomTextStyle(context);

    // Check if there are any vehicles
    if (vehicleProvider.vehicles.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No vehicles found. Please add your vehicles.',
            style: textStyle,
          ),
        ),
      );
    }

    // Display the details of the first vehicle (or change this logic as needed)
    final vehicle = vehicleProvider.vehicles.first;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Main Vehicle Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 10),
            Text('Make: ${vehicle.make}', style: textStyle),
            Text('Model: ${vehicle.model}', style: textStyle),
            Text('Year: ${vehicle.year}', style: textStyle),
            Text('Mileage: ${vehicle.mileage} km', style: textStyle),
          ],
        ),
      ),
    );
  }
}

class UpcomingMaintenanceTasks extends StatelessWidget {
  final MaintenanceProvider maintenanceProvider;

  UpcomingMaintenanceTasks({required this.maintenanceProvider});

  @override
  Widget build(BuildContext context) {
    final textStyle = getCustomTextStyle(context);

    if (maintenanceProvider.tasks.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No upcoming maintenance tasks found.',
            style: textStyle,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Maintenance Tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 10),
            Column(
              children: maintenanceProvider.tasks.map((task) {
                return MaintenanceTaskItem(
                  task: task.task,
                  dueDate: DateFormat('yyyy-MM-dd').format(task.dueDate),
                  mileage: task.mileage,
                  textStyle: textStyle,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class MaintenanceTaskItem extends StatelessWidget {
  final String task;
  final String dueDate;
  final int mileage;
  final TextStyle textStyle;

  MaintenanceTaskItem({
    required this.task,
    required this.dueDate,
    required this.mileage,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(task, style: textStyle),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Due Date: $dueDate', style: textStyle),
              Text('Mileage: $mileage km', style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickAccessFeatures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuickAccessButton(
          icon: Icons.newspaper_rounded,
          label: 'Maintenance schedule',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskListScreen(),
              ),
            );
          },
        ),
        QuickAccessButton(
          icon: Icons.build,
          label: 'Service Log',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ServiceLogScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(icon),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'My Cars',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
      ],
      currentIndex: 0, // This should ideally be managed by a stateful widget
      selectedItemColor: Colors.blue,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VehicleListScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReminderScreen()),
            );
            break;
        }
      },
    );
  }
}
