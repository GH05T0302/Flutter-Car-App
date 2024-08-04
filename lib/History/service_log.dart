class ServiceLog {
  String task;
  String taskID;
  int mileage;
  DateTime dueDate;
  String vehicle;
  DateTime completedDate;

  ServiceLog({
    required this.task,
    required this.taskID,
    required this.mileage,
    required this.dueDate,
    required this.vehicle,
    required this.completedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'taskID': taskID,
      'mileage': mileage,
      'dueDate': dueDate.toIso8601String(),
      'vehicle': vehicle,
      'completedDate': completedDate.toIso8601String(),
    };
  }

  factory ServiceLog.fromMap(Map<String, dynamic> map) {
    return ServiceLog(
      task: map['task'],
      taskID: map['taskID'],
      mileage: map['mileage'],
      dueDate: DateTime.parse(map['dueDate']),
      vehicle: map['vehicle'],
      completedDate: DateTime.parse(map['completedDate']),
    );
  }
}
