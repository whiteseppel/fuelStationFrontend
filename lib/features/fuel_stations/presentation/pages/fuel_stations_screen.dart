import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/fuel_station.dart';
import '../bloc/fuel_stations_bloc.dart';
import '../widgets/station_detail_sheet.dart';

class FuelStationsScreen extends StatelessWidget {
  const FuelStationsScreen({super.key});

  void _openStationDetailSheet(BuildContext context, FuelStation station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<FuelStationsBloc>(),
        child: StationDetailSheet(
          station: station,
          mode: StationSheetMode.view,
        ),
      ),
    );
  }

  void _openCreateStationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<FuelStationsBloc>(),
        child: const StationDetailSheet(
          station: null,
          mode: StationSheetMode.create,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Stations'),
      ),
      body: BlocBuilder<FuelStationsBloc, FuelStationsState>(
        builder: (context, state) {
          if (state is FuelStationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FuelStationsError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else if (state is FuelStationsLoaded) {
            final stations = state.stations;

            final markers = stations.map((station) {
              return Marker(
                width: 40,
                height: 40,
                point: LatLng(station.latitude, station.longitude),
                child: GestureDetector(
                  onTap: () => _openStationDetailSheet(context, station),
                  child: const Icon(Icons.local_gas_station, color: Colors.red, size: 36),
                ),
              );
            }).toList();

            return FlutterMap(
              options: MapOptions(
                initialCenter: stations.isNotEmpty
                    ? LatLng(stations.first.latitude, stations.first.longitude)
                    : LatLng(47.3769, 8.5417),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: markers),
              ],
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateStationSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
