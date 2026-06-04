import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/features/fuel/application/fuel_providers.dart';
import 'package:tracker_flutter/features/fuel/domain/entities/fuel_entry.dart';

class AddFuelEntryScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  const AddFuelEntryScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<AddFuelEntryScreen> createState() => _AddFuelEntryScreenState();
}

class _AddFuelEntryScreenState extends ConsumerState<AddFuelEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _litersController = TextEditingController();
  final _costController = TextEditingController();
  final _mileageController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final entry = FuelEntry(
        id: '',
        vehicleId: widget.vehicleId,
        date: DateTime.now(),
        liters: double.parse(_litersController.text),
        cost: double.parse(_costController.text),
        mileage: double.parse(_mileageController.text),
      );

      await ref.read(fuelNotifierProvider.notifier).addEntry(entry);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fuelNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Fuel Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _litersController,
                decoration: const InputDecoration(labelText: 'Liters'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Invalid number';
                  return null;
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Total Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Invalid number';
                  return null;
                },
              ),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Current Mileage'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              state.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final entry = FuelEntry(
                            id: '',
                            vehicleId: widget.vehicleId,
                            date: DateTime.now(),
                            liters: double.parse(_litersController.text.replaceAll(',', '.')),
                            cost: double.parse(_costController.text.replaceAll(',', '.')),
                            mileage: double.parse(_mileageController.text.replaceAll(',', '.')),
                          );
                          ref.read(fuelNotifierProvider.notifier).addEntry(entry).then((_) {
                            if (mounted && !ref.read(fuelNotifierProvider).hasError) {
                              context.pop();
                            }
                          });
                        }
                      },
                      child: const Text('Save Entry'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
