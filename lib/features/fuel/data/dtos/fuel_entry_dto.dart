import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_flutter/features/fuel/domain/entities/fuel_entry.dart';

class FuelEntryDto {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double liters;
  final double cost;
  final double mileage;

  FuelEntryDto({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.liters,
    required this.cost,
    required this.mileage,
  });

  factory FuelEntryDto.fromJson(Map<String, dynamic> json, String id) {
    return FuelEntryDto(
      id: id,
      vehicleId: json['vehicleId'] as String,
      date: (json['date'] as Timestamp).toDate(),
      liters: (json['liters'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      mileage: (json['mileage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'date': Timestamp.fromDate(date),
      'liters': liters,
      'cost': cost,
      'mileage': mileage,
    };
  }

  FuelEntry toDomain() {
    return FuelEntry(
      id: id,
      vehicleId: vehicleId,
      date: date,
      liters: liters,
      cost: cost,
      mileage: mileage,
    );
  }

  factory FuelEntryDto.fromDomain(FuelEntry entry) {
    return FuelEntryDto(
      id: entry.id,
      vehicleId: entry.vehicleId,
      date: entry.date,
      liters: entry.liters,
      cost: entry.cost,
      mileage: entry.mileage,
    );
  }
}
