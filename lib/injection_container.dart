import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/fuel_stations/data/datasources/fuel_station_remote_data_source.dart';
import 'features/fuel_stations/data/datasources/fuel_station_remote_data_source_impl.dart';
import 'features/fuel_stations/data/repositories/fuel_station_repository_impl.dart';
import 'features/fuel_stations/domain/repositories/fuel_station_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<http.Client>(() => http.Client());

  const baseUrl = 'http://192.168.0.185:3000';
  const apiKey = 'my-secret-key';

  sl.registerLazySingleton<FuelStationRemoteDataSource>(
        () => FuelStationRemoteDataSourceImpl(
      client: sl(),
      apiKey: apiKey,
      baseUrl: baseUrl,
    ),
  );

  sl.registerLazySingleton<FuelStationRepository>(
        () => FuelStationRepositoryImpl(remoteDataSource: sl()),
  );
}
