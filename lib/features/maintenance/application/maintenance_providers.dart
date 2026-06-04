import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/features/auth/application/auth_providers.dart';
import 'package:tracker_flutter/features/maintenance/data/repositories/firestore_maintenance_repository.dart';
import 'package:tracker_flutter/features/maintenance/domain/entities/maintenance_entities.dart';
import 'package:tracker_flutter/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:tracker_flutter/features/vehicles/application/vehicle_providers.dart';

final maintenanceRepositoryProvider = Provider<IMaintenanceRepository>((ref) {
  return FirestoreMaintenanceRepository(ref.watch(firestoreProvider));
});

final maintenanceCategoriesProvider = StreamProvider<List<MaintenanceCategory>>((ref) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(maintenanceRepositoryProvider).watchCategories(user.id);
});

final maintenanceEntriesProvider = StreamProvider.family<List<MaintenanceEntry>, String>((ref, vehicleId) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(maintenanceRepositoryProvider).watchMaintenanceEntries(user.id, vehicleId);
});

final allMaintenanceEntriesProvider = StreamProvider<List<MaintenanceEntry>>((ref) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(maintenanceRepositoryProvider).watchAllMaintenanceEntries(user.id);
});

class MaintenanceNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addEntry(MaintenanceEntry entry) async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(maintenanceRepositoryProvider).addMaintenanceEntry(user.id, entry));
  }

  Future<void> addCategory(String name) async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(maintenanceRepositoryProvider).addCategory(user.id, MaintenanceCategory(id: '', name: name)));
  }
}

final maintenanceNotifierProvider = AsyncNotifierProvider<MaintenanceNotifier, void>(MaintenanceNotifier.new);
