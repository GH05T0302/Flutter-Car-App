import 'package:flutter/material.dart';
import 'package:ggt_assignment/Maintenance/maintenan_sched.dart';
import 'package:ggt_assignment/Maintenance/task_list_screen.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to user profile
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Open menu
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchBar(),
              SizedBox(height: 20),
              VehicleSummary(
                make: 'Toyota',
                model: 'Camry',
                year: 2020,
                mileage: 15000,
              ),
              SizedBox(height: 20),
              UpcomingMaintenanceTasks(),
              SizedBox(height: 20),
              QuickAccessFeatures(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class VehicleSummary extends StatelessWidget {
  final String make;
  final String model;
  final int year;
  final int mileage;

  VehicleSummary({
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Make: $make'),
            Text('Model: $model'),
            Text('Year: $year'),
            Text('Mileage: $mileage km'),
          ],
        ),
      ),
    );
  }
}

class UpcomingMaintenanceTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Maintenance Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MaintenanceTaskItem(
              task: 'Oil Change',
              dueDate: '2024-08-15',
              mileage: 16000,
            ),
            MaintenanceTaskItem(
              task: 'Tire Rotation',
              dueDate: '2024-09-01',
              mileage: 17000,
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

  MaintenanceTaskItem({
    required this.task,
    required this.dueDate,
    required this.mileage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(task),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Due Date: $dueDate'),
              Text('Mileage: $mileage km'),
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
            // Navigate to service log
          },
        ),
        QuickAccessButton(
          icon: Icons.attach_money,
          label: 'Expenses',
          onPressed: () {
            // Navigate to expenses
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
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      onTap: (index) {
        // Handle bottom navigation bar tap
      },
    );
  }
}
