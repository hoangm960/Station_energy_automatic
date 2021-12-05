import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/modules/station_list_module.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../settings/settings_view.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
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
