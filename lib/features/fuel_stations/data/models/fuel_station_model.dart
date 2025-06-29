import '../../domain/entities/fuel_station.dart';
import 'fuel_pump_model.dart';

class FuelStationModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final List<FuelPumpModel> pumps;

  FuelStationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.pumps,
  });

  factory FuelStationModel.fromJson(Map<String, dynamic> json) {
    return FuelStationModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      pumps:
          (json['pumps'] as List<dynamic>)
              .map((e) => FuelPumpModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'pumps': pumps.map((p) => p.toJson()).toList(),
    };
  }

  FuelStation toEntity() {
    return FuelStation(
      id: id,
      name: name,
      address: address,
      city: city,
      latitude: latitude,
      longitude: longitude,
      pumps: pumps.map((p) => p.toEntity()).toList(),
    );
  }

  factory FuelStationModel.fromEntity(FuelStation station) {
    return FuelStationModel(
      id: station.id,
      name: station.name,
      address: station.address,
      city: station.city,
      latitude: station.latitude,
      longitude: station.longitude,
      pumps: station.pumps.map(FuelPumpModel.fromEntity).toList(),
    );
  }
}
