import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/features/fuel/application/fuel_providers.dart';
import 'package:tracker_flutter/features/maintenance/application/maintenance_providers.dart';

class DashboardStats {
  final double totalFuelCost;
  final double totalMaintenanceCost;
  final double totalLiters;
  final Map<String, double> fuelCostPerVehicle;
  final Map<String, double> maintenanceCostPerVehicle;

  DashboardStats({
    required this.totalFuelCost,
    required this.totalMaintenanceCost,
    required this.totalLiters,
    required this.fuelCostPerVehicle,
    required this.maintenanceCostPerVehicle,
  });

  double get totalCost => totalFuelCost + totalMaintenanceCost;
  double get fuelPercentage => totalCost == 0 ? 0 : (totalFuelCost / totalCost) * 100;
  double get maintenancePercentage => totalCost == 0 ? 0 : (totalMaintenanceCost / totalCost) * 100;
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final fuelEntries = ref.watch(allFuelEntriesProvider).value ?? [];
  final maintenanceEntries = ref.watch(allMaintenanceEntriesProvider).value ?? [];

  double totalFuelCost = 0;
  double totalLiters = 0;
  Map<String, double> fuelCostPerVehicle = {};

  for (final entry in fuelEntries) {
    totalFuelCost += entry.cost;
    totalLiters += entry.liters;
    fuelCostPerVehicle[entry.vehicleId] = (fuelCostPerVehicle[entry.vehicleId] ?? 0) + entry.cost;
  }

  double totalMaintenanceCost = 0;
  Map<String, double> maintenanceCostPerVehicle = {};

  for (final entry in maintenanceEntries) {
    totalMaintenanceCost += entry.cost;
    maintenanceCostPerVehicle[entry.vehicleId] = (maintenanceCostPerVehicle[entry.vehicleId] ?? 0) + entry.cost;
  }

  return DashboardStats(
    totalFuelCost: totalFuelCost,
    totalMaintenanceCost: totalMaintenanceCost,
    totalLiters: totalLiters,
    fuelCostPerVehicle: fuelCostPerVehicle,
    maintenanceCostPerVehicle: maintenanceCostPerVehicle,
  );
});
