import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_flutter/features/maintenance/data/dtos/maintenance_dtos.dart';
import 'package:tracker_flutter/features/maintenance/domain/entities/maintenance_entities.dart';
import 'package:tracker_flutter/features/maintenance/domain/repositories/maintenance_repository.dart';

class FirestoreMaintenanceRepository implements IMaintenanceRepository {
  final FirebaseFirestore _firestore;

  FirestoreMaintenanceRepository(this._firestore);

  CollectionReference _entryCollection(String userId) {
    return _firestore
        .collection('customers')
        .doc(userId)
        .collection('maintenance_entries');
  }

  CollectionReference _categoryCollection(String userId) {
    return _firestore
        .collection('customers')
        .doc(userId)
        .collection('categories');
  }

  @override
  Stream<List<MaintenanceCategory>> watchCategories(String userId) {
    return _categoryCollection(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MaintenanceCategoryDto.fromJson(
                doc.data() as Map<String, dynamic>, doc.id)
            .toDomain();
      }).toList();
    });
  }

  @override
  Future<void> addCategory(String userId, MaintenanceCategory category) async {
    await _categoryCollection(userId).add({'name': category.name});
  }

  @override
  Stream<List<MaintenanceEntry>> watchMaintenanceEntries(
      String userId, String vehicleId) {
    return _entryCollection(userId)
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MaintenanceEntryDto.fromJson(
                doc.data() as Map<String, dynamic>, doc.id)
            .toDomain();
      }).toList();
    });
  }

  @override
  Stream<List<MaintenanceEntry>> watchAllMaintenanceEntries(String userId) {
    return _entryCollection(userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MaintenanceEntryDto.fromJson(
                doc.data() as Map<String, dynamic>, doc.id)
            .toDomain();
      }).toList();
    });
  }

  @override
  Future<void> addMaintenanceEntry(String userId, MaintenanceEntry entry) async {
    final dto = MaintenanceEntryDto.fromDomain(entry);
    await _entryCollection(userId).add(dto.toJson());
  }

  @override
  Future<void> deleteMaintenanceEntry(String userId, String entryId) async {
    await _entryCollection(userId).doc(entryId).delete();
  }
}
