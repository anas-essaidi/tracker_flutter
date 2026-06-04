import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_flutter/features/fuel/data/dtos/fuel_entry_dto.dart';
import 'package:tracker_flutter/features/fuel/domain/entities/fuel_entry.dart';
import 'package:tracker_flutter/features/fuel/domain/repositories/fuel_repository.dart';

class FirestoreFuelRepository implements IFuelRepository {
  final FirebaseFirestore _firestore;

  FirestoreFuelRepository(this._firestore);

  CollectionReference _fuelCollection(String userId) {
    return _firestore
        .collection('customers')
        .doc(userId)
        .collection('fuel_entries');
  }

  @override
  Stream<List<FuelEntry>> watchFuelEntries(String userId, String vehicleId) {
    return _fuelCollection(userId)
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FuelEntryDto.fromJson(doc.data() as Map<String, dynamic>, doc.id)
            .toDomain();
      }).toList();
    });
  }

  @override
  Stream<List<FuelEntry>> watchAllFuelEntries(String userId) {
    return _fuelCollection(userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FuelEntryDto.fromJson(doc.data() as Map<String, dynamic>, doc.id)
            .toDomain();
      }).toList();
    });
  }

  @override
  Future<void> addFuelEntry(String userId, FuelEntry entry) async {
    final dto = FuelEntryDto.fromDomain(entry);
    await _fuelCollection(userId).add(dto.toJson());
  }

  @override
  Future<void> deleteFuelEntry(String userId, String entryId) async {
    await _fuelCollection(userId).doc(entryId).delete();
  }
}
