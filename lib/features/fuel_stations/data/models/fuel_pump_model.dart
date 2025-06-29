import '../../domain/entities/fuel_station.dart';

class FuelPumpModel {
  final int id;
  final String fuelType;
  final double price;
  final bool available;

  FuelPumpModel({
    required this.id,
    required this.fuelType,
    required this.price,
    required this.available,
  });

  factory FuelPumpModel.fromJson(Map<String, dynamic> json) {
    return FuelPumpModel(
      id: json['id'],
      fuelType: json['fuel_type'],
      price: (json['price'] as num).toDouble(),
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fuel_type': fuelType,
      'price': price,
      'available': available,
    };
  }

  FuelPump toEntity() {
    return FuelPump(
      id: id,
      fuelType: fuelType,
      price: price,
      available: available,
    );
  }

  factory FuelPumpModel.fromEntity(FuelPump pump) {
    return FuelPumpModel(
      id: pump.id,
      fuelType: pump.fuelType,
      price: pump.price,
      available: pump.available,
    );
  }
}
