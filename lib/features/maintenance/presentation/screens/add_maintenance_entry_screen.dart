import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/features/maintenance/application/maintenance_providers.dart';
import 'package:tracker_flutter/features/maintenance/domain/entities/maintenance_entities.dart';

class AddMaintenanceEntryScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  const AddMaintenanceEntryScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<AddMaintenanceEntryScreen> createState() => _AddMaintenanceEntryScreenState();
}

class _AddMaintenanceEntryScreenState extends ConsumerState<AddMaintenanceEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _costController = TextEditingController();
  final _mileageController = TextEditingController();
  String? _selectedCategoryId;

  @override
  void dispose() {
    _descController.dispose();
    _costController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. Oil Change, Tires...'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(maintenanceNotifierProvider.notifier).addCategory(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(maintenanceNotifierProvider);
    final categoriesAsync = ref.watch(maintenanceCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: categoriesAsync.when(
                        data: (categories) => DropdownButtonFormField<String>(
                          value: _selectedCategoryId,
                          decoration: const InputDecoration(labelText: 'Category'),
                          items: categories.map((cat) => DropdownMenuItem(
                            value: cat.id,
                            child: Text(cat.name),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedCategoryId = val),
                          validator: (val) => val == null ? 'Required' : null,
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (err, _) => const Text('Error loading categories'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => _showAddCategoryDialog(context),
                      tooltip: 'Add New Category',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _costController,
                  decoration: const InputDecoration(labelText: 'Cost'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Invalid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mileageController,
                  decoration: const InputDecoration(labelText: 'Mileage'),
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
                          if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
                            final entry = MaintenanceEntry(
                              id: '',
                              vehicleId: widget.vehicleId,
                              categoryId: _selectedCategoryId!,
                              date: DateTime.now(),
                              description: _descController.text,
                              cost: double.parse(_costController.text.replaceAll(',', '.')),
                              mileage: double.parse(_mileageController.text.replaceAll(',', '.')),
                            );
                            ref.read(maintenanceNotifierProvider.notifier).addEntry(entry).then((_) {
                              if (mounted && !ref.read(maintenanceNotifierProvider).hasError) {
                                context.pop();
                              }
                            });
                          } else if (_selectedCategoryId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select or add a category')),
                            );
                          }
                        },
                        child: const Text('Save Maintenance'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
