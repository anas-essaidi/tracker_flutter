import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/features/auth/application/auth_providers.dart';
import 'package:tracker_flutter/features/fuel/data/repositories/firestore_fuel_repository.dart';
import 'package:tracker_flutter/features/fuel/domain/entities/fuel_entry.dart';
import 'package:tracker_flutter/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:tracker_flutter/features/vehicles/application/vehicle_providers.dart';

final fuelRepositoryProvider = Provider<IFuelRepository>((ref) {
  return FirestoreFuelRepository(ref.watch(firestoreProvider));
});

final fuelEntriesProvider = StreamProvider.family<List<FuelEntry>, String>((ref, vehicleId) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(fuelRepositoryProvider).watchFuelEntries(user.id, vehicleId);
});

final allFuelEntriesProvider = StreamProvider<List<FuelEntry>>((ref) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(fuelRepositoryProvider).watchAllFuelEntries(user.id);
});

class FuelNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addEntry(FuelEntry entry) async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(fuelRepositoryProvider).addFuelEntry(user.id, entry));
  }
}

final fuelNotifierProvider = AsyncNotifierProvider<FuelNotifier, void>(FuelNotifier.new);
