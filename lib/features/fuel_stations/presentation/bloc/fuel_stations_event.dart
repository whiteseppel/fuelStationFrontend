part of 'fuel_stations_bloc.dart';

abstract class FuelStationsEvent {}

class LoadFuelStations extends FuelStationsEvent {}

class AddFuelStation extends FuelStationsEvent {
  final FuelStation station;
  AddFuelStation(this.station);
}

class UpdateFuelStation extends FuelStationsEvent {
  final FuelStation station;
  UpdateFuelStation(this.station);
}

class DeleteFuelStation extends FuelStationsEvent {
  final String stationId;
  DeleteFuelStation(this.stationId);
}
