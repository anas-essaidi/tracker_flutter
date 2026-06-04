import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_flutter/features/vehicles/data/dtos/vehicle_dto.dart';
import 'package:tracker_flutter/features/vehicles/domain/entities/vehicle.dart';
import 'package:tracker_flutter/features/vehicles/domain/repositories/vehicle_repository.dart';

class FirestoreVehicleRepository implements IVehicleRepository {
  final FirebaseFirestore _firestore;

  FirestoreVehicleRepository(this._firestore);

  CollectionReference _vehicleCollection(String userId) {
    return _firestore
        .collection('customers')
        .doc(userId)
        .collection('vehicles');
  }

  @override
  Stream<List<Vehicle>> watchVehicles(String userId) {
    return _vehicleCollection(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return VehicleDto.fromJson(doc.data() as Map<String, dynamic>, doc.id)
            .toDomain();
      }).toList();
    });
  }

  @override
  Future<void> addVehicle(String userId, Vehicle vehicle) async {
    final dto = VehicleDto.fromDomain(vehicle);
    await _vehicleCollection(userId).add(dto.toJson());
  }

  @override
  Future<void> updateVehicle(String userId, Vehicle vehicle) async {
    final dto = VehicleDto.fromDomain(vehicle);
    await _vehicleCollection(userId).doc(vehicle.id).update(dto.toJson());
  }

  @override
  Future<void> deleteVehicle(String userId, String vehicleId) async {
    await _vehicleCollection(userId).doc(vehicleId).delete();
  }
}
