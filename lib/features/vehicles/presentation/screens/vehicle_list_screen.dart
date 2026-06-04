import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/features/vehicles/application/vehicle_providers.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
      ),
      body: vehiclesAsync.when(
        data: (vehicles) => vehicles.isEmpty
            ? const Center(child: Text('No vehicles added yet.'))
            : ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(vehicle.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Plate: ${vehicle.plateNumber}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => ref
                                .read(vehicleNotifierProvider.notifier)
                                .deleteVehicle(vehicle.id),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.local_gas_station),
                                label: const Text('Add Fuel'),
                                onPressed: () => context.push('/vehicles/${vehicle.id}/fuel/add'),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.build),
                                label: const Text('Maintenance'),
                                onPressed: () => context.push('/vehicles/${vehicle.id}/maintenance/add'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
