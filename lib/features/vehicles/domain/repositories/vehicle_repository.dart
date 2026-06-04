import 'package:tracker_flutter/features/vehicles/domain/entities/vehicle.dart';

abstract class IVehicleRepository {
  Stream<List<Vehicle>> watchVehicles(String userId);
  Future<void> addVehicle(String userId, Vehicle vehicle);
  Future<void> updateVehicle(String userId, Vehicle vehicle);
  Future<void> deleteVehicle(String userId, String vehicleId);
}
