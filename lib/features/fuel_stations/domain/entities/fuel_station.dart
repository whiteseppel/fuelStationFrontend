class FuelPump {
  final int id;
  final String fuelType;
  final double price;
  final bool available;

  FuelPump({
    required this.id,
    required this.fuelType,
    required this.price,
    required this.available,
  });
}

class FuelStation {
  final String id;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final List<FuelPump> pumps;

  FuelStation({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.pumps,
  });
}

