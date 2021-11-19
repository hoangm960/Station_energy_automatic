import 'package:flutter/material.dart';
import 'package:ocean_station_auto/modules/station_list_module.dart';
import 'package:ocean_station_auto/models/station_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ocean Station Automation'),
        ),
        body: StationList([
          Station(
              name: 'Station 1',
              location: Location(x: 100, y: 200),
              power: 100,
              state: false),
          Station(
              name: 'Station 2',
              location: Location(x: 50, y: 20),
              power: 220,
              state: true),
          Station(
              name: 'Station 3',
              location: Location(x: 300, y: 300),
              power: 220,
              state: true),
        ]));
  }
}
