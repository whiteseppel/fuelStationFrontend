import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/fuel_station.dart';
import '../../domain/repositories/fuel_station_repository.dart';

part 'fuel_stations_event.dart';
part 'fuel_stations_state.dart';

class FuelStationsBloc extends Bloc<FuelStationsEvent, FuelStationsState> {
  final FuelStationRepository repository;

  FuelStationsBloc({required this.repository}) : super(FuelStationsInitial()) {
    on<LoadFuelStations>(_onLoadFuelStations);
    on<AddFuelStation>(_onAddFuelStation);
    on<UpdateFuelStation>(_onUpdateFuelStation);
    on<DeleteFuelStation>(_onDeleteFuelStation);
  }

  Future<void> _onLoadFuelStations(
    LoadFuelStations event,
    Emitter<FuelStationsState> emit,
  ) async {
    emit(FuelStationsLoading());
    try {
      final stations = await repository.getAllStations();
      emit(FuelStationsLoaded(stations));
    } catch (e) {
      emit(FuelStationsError('Failed to load fuel stations'));
    }
  }

  Future<void> _onAddFuelStation(
    AddFuelStation event,
    Emitter<FuelStationsState> emit,
  ) async {
    try {
      await repository.createStation(event.station);
      add(LoadFuelStations());
    } catch (e) {
      emit(FuelStationsError('Failed to add fuel station'));
    }
  }

  Future<void> _onUpdateFuelStation(
    UpdateFuelStation event,
    Emitter<FuelStationsState> emit,
  ) async {
    try {
      await repository.updateStation(event.station);
      add(LoadFuelStations());
    } catch (e) {
      emit(FuelStationsError('Failed to update fuel station'));
    }
  }

  Future<void> _onDeleteFuelStation(
    DeleteFuelStation event,
    Emitter<FuelStationsState> emit,
  ) async {
    try {
      await repository.deleteStation(event.stationId);
      add(LoadFuelStations());
    } catch (e) {
      emit(FuelStationsError('Failed to delete fuel station'));
    }
  }
}
