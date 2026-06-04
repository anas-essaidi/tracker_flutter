import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_flutter/features/maintenance/domain/entities/maintenance_entities.dart';

class MaintenanceCategoryDto {
  final String id;
  final String name;

  MaintenanceCategoryDto({required this.id, required this.name});

  factory MaintenanceCategoryDto.fromJson(Map<String, dynamic> json, String id) {
    return MaintenanceCategoryDto(id: id, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() => {'name': name};

  MaintenanceCategory toDomain() => MaintenanceCategory(id: id, name: name);
}

class MaintenanceEntryDto {
  final String id;
  final String vehicleId;
  final String categoryId;
  final DateTime date;
  final String description;
  final double cost;
  final double mileage;

  MaintenanceEntryDto({
    required this.id,
    required this.vehicleId,
    required this.categoryId,
    required this.date,
    required this.description,
    required this.cost,
    required this.mileage,
  });

  factory MaintenanceEntryDto.fromJson(Map<String, dynamic> json, String id) {
    return MaintenanceEntryDto(
      id: id,
      vehicleId: json['vehicleId'] as String,
      categoryId: json['categoryId'] as String,
      date: (json['date'] as Timestamp).toDate(),
      description: json['description'] as String,
      cost: (json['cost'] as num).toDouble(),
      mileage: (json['mileage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'description': description,
      'cost': cost,
      'mileage': mileage,
    };
  }

  MaintenanceEntry toDomain() {
    return MaintenanceEntry(
      id: id,
      vehicleId: vehicleId,
      categoryId: categoryId,
      date: date,
      description: description,
      cost: cost,
      mileage: mileage,
    );
  }

  factory MaintenanceEntryDto.fromDomain(MaintenanceEntry entry) {
    return MaintenanceEntryDto(
      id: entry.id,
      vehicleId: entry.vehicleId,
      categoryId: entry.categoryId,
      date: entry.date,
      description: entry.description,
      cost: entry.cost,
      mileage: entry.mileage,
    );
  }
}
