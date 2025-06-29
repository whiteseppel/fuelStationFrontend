part of 'fuel_stations_bloc.dart';

abstract class FuelStationsState {}

class FuelStationsInitial extends FuelStationsState {}

class FuelStationsLoading extends FuelStationsState {}

class FuelStationsLoaded extends FuelStationsState {
  final List<FuelStation> stations;

  FuelStationsLoaded(this.stations);
}

class FuelStationsError extends FuelStationsState {
  final String message;

  FuelStationsError(this.message);
}
