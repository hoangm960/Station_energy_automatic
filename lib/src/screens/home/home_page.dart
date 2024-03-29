import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/screens/home/components/add_station.dart';
import 'package:ocean_station_auto/src/screens/home/components/station_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ocean_station_auto/src/screens/profile_page.dart';
import '../../settings/settings_view.dart';
import '../../state_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StationListView stationList = const StationListView();
  late User _user;

  void refresh() {
    setState(() {
      stationList = const StationListView();
    });
  }

  void addStation() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AddStation(notifyParrent: refresh));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    _user = container.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.restorablePushNamed(context, ProfileScreen.routeName);
              },
              icon: const Icon(Icons.person)),
          const SizedBox(
            width: 16.0,
          ),
        ],
      ),
      body: stationList,
      floatingActionButton: _user.typeId == 1
          ? FloatingActionButton(
              onPressed: () => addStation(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
