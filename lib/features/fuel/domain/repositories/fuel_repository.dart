import 'package:tracker_flutter/features/fuel/domain/entities/fuel_entry.dart';

abstract class IFuelRepository {
  Stream<List<FuelEntry>> watchFuelEntries(String userId, String vehicleId);
  Stream<List<FuelEntry>> watchAllFuelEntries(String userId);
  Future<void> addFuelEntry(String userId, FuelEntry entry);
  Future<void> deleteFuelEntry(String userId, String entryId);
}
