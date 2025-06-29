import '../models/fuel_station_model.dart';

abstract class FuelStationRemoteDataSource {
  Future<List<FuelStationModel>> fetchStations();
  Future<void> updateStation(FuelStationModel station);
  Future<void> createStation(FuelStationModel station);
  Future<void> deleteStation(String stationId);
}
