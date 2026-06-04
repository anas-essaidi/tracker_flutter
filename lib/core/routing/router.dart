import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/features/auth/application/auth_providers.dart';
import 'package:tracker_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:tracker_flutter/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tracker_flutter/features/vehicles/presentation/screens/vehicle_list_screen.dart';
import 'package:tracker_flutter/features/vehicles/presentation/screens/add_vehicle_screen.dart';
import 'package:tracker_flutter/features/fuel/presentation/screens/add_fuel_entry_screen.dart';
import 'package:tracker_flutter/features/maintenance/presentation/screens/add_maintenance_entry_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final user = authState.value;
      final loggingIn = state.uri.path == '/login';

      if (user == null) {
        return loggingIn ? null : '/login';
      }

      if (loggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'vehicles',
            builder: (context, state) => const VehicleListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddVehicleScreen(),
              ),
              GoRoute(
                path: ':vehicleId/fuel/add',
                builder: (context, state) => AddFuelEntryScreen(
                  vehicleId: state.pathParameters['vehicleId']!,
                ),
              ),
              GoRoute(
                path: ':vehicleId/maintenance/add',
                builder: (context, state) => AddMaintenanceEntryScreen(
                  vehicleId: state.pathParameters['vehicleId']!,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
});
