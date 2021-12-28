import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/screens/home/components/station_list_module.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ocean_station_auto/src/screens/profile_page.dart';
import '../../settings/settings_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

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
                onPressed: () {
                  Navigator.restorablePushNamed(
                      context, ProfileScreen.routeName);
                },
                icon: const Icon(Icons.person)),
            const SizedBox(
              width: 16.0,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: StationList(stationList));
  }
}
