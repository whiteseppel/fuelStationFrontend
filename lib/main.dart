import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/fuel_stations/presentation/pages/fuel_stations_screen.dart';
import 'injection_container.dart' as di;
import 'features/fuel_stations/presentation/bloc/fuel_stations_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Stations Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create:
            (_) =>
                FuelStationsBloc(repository: di.sl())..add(LoadFuelStations()),
        child: const FuelStationsScreen(),
      ),
    );
  }
}
