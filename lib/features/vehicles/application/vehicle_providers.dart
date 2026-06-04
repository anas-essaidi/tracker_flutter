import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/features/auth/application/auth_providers.dart';
import 'package:tracker_flutter/features/vehicles/data/repositories/firestore_vehicle_repository.dart';
import 'package:tracker_flutter/features/vehicles/domain/entities/vehicle.dart';
import 'package:tracker_flutter/features/vehicles/domain/repositories/vehicle_repository.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final vehicleRepositoryProvider = Provider<IVehicleRepository>((ref) {
  return FirestoreVehicleRepository(ref.watch(firestoreProvider));
});

final vehiclesStreamProvider = StreamProvider<List<Vehicle>>((ref) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(vehicleRepositoryProvider).watchVehicles(user.id);
});

class VehicleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addVehicle(Vehicle vehicle) async {
    final user = ref.read(authNotifierProvider).value;
    print('Attempting to add vehicle for user: ${user?.id}');
    if (user == null) {
      print('User is null, cannot add vehicle');
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      print('Calling repository to add vehicle: ${vehicle.name}');
      await ref.read(vehicleRepositoryProvider).addVehicle(user.id, vehicle);
      print('Vehicle added successfully in repository');
    });
    
    if (state.hasError) {
      print('Error adding vehicle: ${state.error}');
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(vehicleRepositoryProvider).deleteVehicle(user.id, vehicleId));
  }
}

final vehicleNotifierProvider =
    AsyncNotifierProvider<VehicleNotifier, void>(VehicleNotifier.new);
