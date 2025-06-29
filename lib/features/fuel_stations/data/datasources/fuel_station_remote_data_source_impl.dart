import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fuel_station_model.dart';
import 'fuel_station_remote_data_source.dart';

const String fuelStationPath = 'api/fuel-stations';

class FuelStationRemoteDataSourceImpl implements FuelStationRemoteDataSource {
  final http.Client client;
  final String apiKey;
  final String baseUrl;

  FuelStationRemoteDataSourceImpl({
    required this.client,
    required this.apiKey,
    required this.baseUrl,
  });

  Map<String, String> get _headers => {
    'x-api-Key': apiKey,
    'Content-Type': 'application/json',
  };

  @override
  Future<List<FuelStationModel>> fetchStations() async {
    final response = await client.get(
      Uri.parse('$baseUrl/$fuelStationPath'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fuel stations');
    }

    final List<dynamic> decoded = json.decode(response.body);
    return decoded.map((e) => FuelStationModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateStation(FuelStationModel station) async {
    final response = await client.put(
      Uri.parse('$baseUrl/$fuelStationPath/${station.id}'),
      headers: _headers,
      body: json.encode(station.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update fuel station');
    }
  }

  @override
  Future<void> createStation(FuelStationModel station) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$fuelStationPath'),
      headers: _headers,
      body: json.encode(station.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create fuel station');
    }
  }

  @override
  Future<void> deleteStation(String stationId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$fuelStationPath/$stationId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete fuel station');
    }
  }
}
