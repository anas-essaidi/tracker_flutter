import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/features/vehicles/application/vehicle_providers.dart';
import 'package:tracker_flutter/features/vehicles/domain/entities/vehicle.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _plateController = TextEditingController();
  final _mileageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _plateController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final vehicle = Vehicle(
        id: '', // Firestore will generate the ID
        name: _nameController.text,
        plateNumber: _plateController.text,
        initialMileage: double.parse(_mileageController.text),
      );

      await ref.read(vehicleNotifierProvider.notifier).addVehicle(vehicle);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleNotifierProvider);

    ref.listen(vehicleNotifierProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Add Vehicle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Vehicle Name (e.g. Toyota Hilux)'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(labelText: 'Plate Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Initial Mileage'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final n = double.tryParse(value.replaceAll(',', '.'));
                  if (n == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              state.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final vehicle = Vehicle(
                            id: '',
                            name: _nameController.text,
                            plateNumber: _plateController.text,
                            initialMileage: double.parse(_mileageController.text.replaceAll(',', '.')),
                          );
                          ref.read(vehicleNotifierProvider.notifier).addVehicle(vehicle).then((_) {
                            if (mounted && !ref.read(vehicleNotifierProvider).hasError) {
                              context.pop();
                            }
                          });
                        }
                      },
                      child: const Text('Save Vehicle'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
