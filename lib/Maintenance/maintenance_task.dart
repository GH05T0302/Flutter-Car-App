class MaintenanceTask {
  String task;
  String taskID;
  int mileage;
  DateTime dueDate;
  String vehicle;

  MaintenanceTask({
    required this.task,
    required this.taskID,
    required this.mileage,
    required DateTime dueDate,
    required this.vehicle,
  }) : dueDate = DateTime(dueDate.year, dueDate.month, dueDate.day); // Ensure only date is stored

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'taskID': taskID,
      'mileage': mileage,
      'dueDate': dueDate.toIso8601String(),
      'vehicle': vehicle,
    };
  }

  factory MaintenanceTask.fromMap(Map<String, dynamic> map) {
    return MaintenanceTask(
      task: map['task'],
      taskID: map['taskID'],
      mileage: map['mileage'],
      dueDate: DateTime.parse(map['dueDate']).toLocal(), // Convert to local date without time
      vehicle: map['vehicle'],
    );
  }
}
