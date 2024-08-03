class MaintenanceTask {
  String id;
  String name;
  String description;
  DateTime date;
  int mileage;
  bool isMileageBased;

  MaintenanceTask({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.mileage,
    required this.isMileageBased,
  });
}
