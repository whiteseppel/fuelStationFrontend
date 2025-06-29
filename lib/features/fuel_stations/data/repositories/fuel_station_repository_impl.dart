import '../../domain/entities/fuel_station.dart';
import '../../domain/repositories/fuel_station_repository.dart';
import '../datasources/fuel_station_remote_data_source.dart';
import '../models/fuel_station_model.dart';

class FuelStationRepositoryImpl implements FuelStationRepository {
  final FuelStationRemoteDataSource remoteDataSource;

  FuelStationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FuelStation>> getAllStations() async {
    final models = await remoteDataSource.fetchStations();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateStation(FuelStation station) async {
    final model = FuelStationModel.fromEntity(station);
    await remoteDataSource.updateStation(model);
  }

  @override
  Future<void> createStation(FuelStation station) async {
    final model = FuelStationModel.fromEntity(station);
    await remoteDataSource.createStation(model);
  }

  @override
  Future<void> deleteStation(String stationId) async {
    await remoteDataSource.deleteStation(stationId);
  }
}
