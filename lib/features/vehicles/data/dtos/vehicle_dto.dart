import 'package:tracker_flutter/features/vehicles/domain/entities/vehicle.dart';

class VehicleDto {
  final String id;
  final String name;
  final String plateNumber;
  final double initialMileage;

  VehicleDto({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.initialMileage,
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json, String id) {
    return VehicleDto(
      id: id,
      name: json['name'] as String,
      plateNumber: json['plateNumber'] as String,
      initialMileage: (json['initialMileage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'plateNumber': plateNumber,
      'initialMileage': initialMileage,
    };
  }

  Vehicle toDomain() {
    return Vehicle(
      id: id,
      name: name,
      plateNumber: plateNumber,
      initialMileage: initialMileage,
    );
  }

  factory VehicleDto.fromDomain(Vehicle vehicle) {
    return VehicleDto(
      id: vehicle.id,
      name: vehicle.name,
      plateNumber: vehicle.plateNumber,
      initialMileage: vehicle.initialMileage,
    );
  }
}
