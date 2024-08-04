class Vehicle {
  String make;
  String model;
  int year;
  int mileage;

  Vehicle({
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
  });

  Map<String, dynamic> toMap() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'mileage': mileage,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      make: map['make'] ?? 'Unknown', // Provide a default value if null
      model: map['model'] ?? 'Unknown', // Provide a default value if null
      year: map['year'] != null ? map['year'] as int : 0, // Handle potential null value
      mileage: map['mileage'] != null ? map['mileage'] as int : 0, // Handle potential null value
    );
  }

  Vehicle copyWith({
    String? make,
    String? model,
    int? year,
    int? mileage,
  }) {
    return Vehicle(
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      mileage: mileage ?? this.mileage,
    );
  }
}
