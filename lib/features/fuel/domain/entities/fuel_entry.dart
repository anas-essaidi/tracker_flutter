class FuelEntry {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double liters;
  final double cost;
  final double mileage;

  const FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.liters,
    required this.cost,
    required this.mileage,
  });
}
