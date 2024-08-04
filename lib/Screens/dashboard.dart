import 'package:flutter/material.dart';
import 'package:ggt_assignment/themeProvider.dart';
import 'package:ggt_assignment/widgets/customTextStyle.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/Maintenance/task_list_screen.dart';
import 'package:ggt_assignment/Screens/vehicleList.dart';
import 'package:ggt_assignment/History/service_log_screen.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.account_circle),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Profile')),
              PopupMenuItem<int>(value: 1, child: Text('Settings')),
            ],
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

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // Navigate to user profile
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
    final textStyle = getCustomTextStyle(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 10),
            Text('Make: $make', style: textStyle),
            Text('Model: $model', style: textStyle),
            Text('Year: $year', style: textStyle),
            Text('Mileage: $mileage km', style: textStyle),
          ],
        ),
      ),
    );
  }
}

class UpcomingMaintenanceTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = getCustomTextStyle(context);

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
            MaintenanceTaskItem(
              task: 'Oil Change',
              dueDate: '2024-08-15',
              mileage: 16000,
              textStyle: textStyle,
            ),
            MaintenanceTaskItem(
              task: 'Tire Rotation',
              dueDate: '2024-09-01',
              mileage: 17000,
              textStyle: textStyle,
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
            // Add navigation for Alerts if needed
            break;
        }
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
