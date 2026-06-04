import 'package:tracker_flutter/features/maintenance/domain/entities/maintenance_entities.dart';

abstract class IMaintenanceRepository {
  Stream<List<MaintenanceCategory>> watchCategories(String userId);
  Future<void> addCategory(String userId, MaintenanceCategory category);
  
  Stream<List<MaintenanceEntry>> watchMaintenanceEntries(String userId, String vehicleId);
  Stream<List<MaintenanceEntry>> watchAllMaintenanceEntries(String userId);
  Future<void> addMaintenanceEntry(String userId, MaintenanceEntry entry);
  Future<void> deleteMaintenanceEntry(String userId, String entryId);
}
