import '../entities/fuel_station.dart';

abstract class FuelStationRepository {
  Future<List<FuelStation>> getAllStations();
  Future<void> updateStation(FuelStation station);
  Future<void> createStation(FuelStation station);
  Future<void> deleteStation(String stationId);
}
