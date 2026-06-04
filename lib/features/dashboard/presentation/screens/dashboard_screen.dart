import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/features/auth/application/auth_providers.dart';
import 'package:tracker_flutter/features/dashboard/application/dashboard_providers.dart';
import 'package:tracker_flutter/features/vehicles/application/vehicle_providers.dart';
import 'package:tracker_flutter/features/fuel/application/fuel_providers.dart';
import 'package:tracker_flutter/features/maintenance/application/maintenance_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;
    final stats = ref.watch(dashboardStatsProvider);
    final vehiclesAsync = ref.watch(vehiclesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diesel & Maintenance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allFuelEntriesProvider);
          ref.invalidate(allMaintenanceEntriesProvider);
          ref.invalidate(vehiclesStreamProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user?.email ?? 'User'}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // Summary Card
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Total Expenses (All Time)', style: TextStyle(fontSize: 16)),
                      Text(
                        '${stats.totalCost.toStringAsFixed(2)} €',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            label: 'Diesel',
                            value: '${stats.fuelPercentage.toStringAsFixed(0)}%',
                            color: Colors.orange,
                          ),
                          _StatItem(
                            label: 'Maintenance',
                            value: '${stats.maintenancePercentage.toStringAsFixed(0)}%',
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              const Text('Vehicles Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              
              vehiclesAsync.when(
                data: (vehicles) => vehicles.isEmpty
                    ? const Center(child: Text('No vehicles yet. Add one to start tracking.'))
                    : Column(
                        children: vehicles.map((vehicle) {
                          final fuelCost = stats.fuelCostPerVehicle[vehicle.id] ?? 0;
                          final maintenanceCost = stats.maintenanceCostPerVehicle[vehicle.id] ?? 0;
                          
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.directions_car),
                              title: Text(vehicle.name),
                              subtitle: Text('Fuel: ${fuelCost.toStringAsFixed(2)}€ | Maint: ${maintenanceCost.toStringAsFixed(2)}€'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.push('/vehicles'),
                            ),
                          );
                        }).toList(),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading vehicles: $err'),
              ),
              
              const SizedBox(height: 24),
              const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _DashboardAction(
                title: 'Manage Vehicles',
                icon: Icons.settings,
                onTap: () => context.push('/vehicles'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _DashboardAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardAction({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
