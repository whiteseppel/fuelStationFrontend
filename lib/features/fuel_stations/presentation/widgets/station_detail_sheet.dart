import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/fuel_station.dart';
import '../bloc/fuel_stations_bloc.dart';

enum StationSheetMode { view, edit, create }

class StationDetailSheet extends StatefulWidget {
  final FuelStation? station;
  final StationSheetMode mode;

  const StationDetailSheet({super.key, this.station, required this.mode});

  @override
  State<StationDetailSheet> createState() => _StationDetailSheetState();
}

class _StationDetailSheetState extends State<StationDetailSheet> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late StationSheetMode mode;

  late List<TextEditingController> fuelTypeControllers;
  late List<TextEditingController> priceControllers;
  late List<bool> availability;

  @override
  void initState() {
    super.initState();
    mode = widget.mode;

    final s = widget.station;
    nameController = TextEditingController(text: s?.name ?? '');
    addressController = TextEditingController(text: s?.address ?? '');
    cityController = TextEditingController(text: s?.city ?? '');
    latController = TextEditingController(text: s?.latitude.toString() ?? '');
    lngController = TextEditingController(text: s?.longitude.toString() ?? '');

    final pumps = List<FuelPump>.from(s?.pumps ?? []);

    fuelTypeControllers = pumps.map((p) => TextEditingController(text: p.fuelType)).toList();
    priceControllers = pumps.map((p) => TextEditingController(text: p.price.toStringAsFixed(2))).toList();
    availability = pumps.map((p) => p.available).toList();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    latController.dispose();
    lngController.dispose();
    for (final c in fuelTypeControllers) {
      c.dispose();
    }
    for (final c in priceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onSave() {
    final List<FuelPump> updatedPumps = [];
    for (int i = 0; i < availability.length; i++) {
      updatedPumps.add(
          FuelPump(
            id: i + 1,
            fuelType: fuelTypeControllers[i].text,
            price: double.tryParse(priceControllers[i].text) ?? 0.0,
            available: availability[i],
          ));
    }

    final updated = FuelStation(
      id: widget.station?.id ?? 'new_${DateTime.now().millisecondsSinceEpoch}',
      name: nameController.text,
      address: addressController.text,
      city: cityController.text,
      latitude: double.tryParse(latController.text) ?? 0.0,
      longitude: double.tryParse(lngController.text) ?? 0.0,
      pumps: updatedPumps,
    );

    if (mode == StationSheetMode.create) {
      context.read<FuelStationsBloc>().add(AddFuelStation(updated));
    }

    if (mode == StationSheetMode.edit) {
      context.read<FuelStationsBloc>().add(UpdateFuelStation(updated));
    }

    Navigator.pop(context);
  }

  void _onDelete() {
    context.read<FuelStationsBloc>().add(DeleteFuelStation(widget.station!.id));
    Navigator.pop(context, 'delete');
  }

  void _addPump() {
    setState(() {
      fuelTypeControllers.add(TextEditingController(text: 'NEW'));
      priceControllers.add(TextEditingController(text: '0.00'));
      availability.add(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = mode == StationSheetMode.edit || mode == StationSheetMode.create;
    final isCreate = mode == StationSheetMode.create;

    final title = switch (mode) {
      StationSheetMode.view => 'Fuel Station Details',
      StationSheetMode.edit => 'Edit Station',
      StationSheetMode.create => 'Create Station',
    };

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
                  if (mode == StationSheetMode.view)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => setState(() => mode = StationSheetMode.edit),
                    ),
                  if (isEditable)
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _onSave,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                enabled: isEditable,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: addressController,
                enabled: isCreate,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: cityController,
                enabled: isCreate,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: latController,
                      enabled: isCreate,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: lngController,
                      enabled: isCreate,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isCreate)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addPump,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Pump'),
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: fuelTypeControllers.length,
                itemBuilder: (context, index) {

                  return ListTile(
                    title: isCreate
                        ? TextField(
                      controller: fuelTypeControllers[index],
                      decoration: const InputDecoration(labelText: 'Fuel Type'),
                    )
                        : Text(fuelTypeControllers[index].text),
                    subtitle: isEditable
                        ? TextField(
                      controller: priceControllers[index],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price (CHF)'),
                    )
                        : Text('Price: ${priceControllers[index].text} CHF'),
                    trailing: isCreate
                        ? Switch(
                      value: availability[index],
                      onChanged: (val) {
                        setState(() {
                          availability[index] = val;
                        });
                      },
                    )
                        : Text(availability[index] ? 'Available' : 'Unavailable'),
                  );
                },
              ),
              if (mode == StationSheetMode.edit)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: _onDelete,
                    child: const Text('Delete'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
