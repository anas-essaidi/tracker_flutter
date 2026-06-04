class MaintenanceCategory {
  final String id;
  final String name;

  const MaintenanceCategory({
    required this.id,
    required this.name,
  });
}

class MaintenanceEntry {
  final String id;
  final String vehicleId;
  final String categoryId;
  final DateTime date;
  final String description;
  final double cost;
  final double mileage;

  const MaintenanceEntry({
    required this.id,
    required this.vehicleId,
    required this.categoryId,
    required this.date,
    required this.description,
    required this.cost,
    required this.mileage,
  });
}
