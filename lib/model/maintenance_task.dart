class MaintenanceTask {
  String task;
  String taskID;
  int mileage;
  DateTime dueDate;
  String vehicle; // Add this line
  bool isCompleted;

  MaintenanceTask({
    required this.task,
    required this.taskID,
    required this.mileage,
    required this.dueDate,
    required this.vehicle, // Add this line
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'taskID': taskID,
      'mileage': mileage,
      'dueDate': dueDate.toIso8601String(),
      'vehicle': vehicle, // Add this line
      'isCompleted': isCompleted,
    };
  }

  factory MaintenanceTask.fromMap(Map<String, dynamic> map) {
    return MaintenanceTask(
      task: map['task'],
      taskID: map['taskID'],
      mileage: map['mileage'],
      dueDate: DateTime.parse(map['dueDate']),
      vehicle: map['vehicle'], // Add this line
      isCompleted: map['isCompleted'],
    );
  }
}
