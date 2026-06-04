class Vehicle {
  final String id;
  final String name;
  final String plateNumber;
  final double initialMileage;

  const Vehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.initialMileage,
  });

  Vehicle copyWith({
    String? id,
    String? name,
    String? plateNumber,
    double? initialMileage,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      initialMileage: initialMileage ?? this.initialMileage,
    );
  }
}
