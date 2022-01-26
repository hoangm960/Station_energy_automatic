import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/station_list.dart';
import 'package:ocean_station_auto/src/screens/profile_page.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/map.dart';
import 'package:ocean_station_auto/src/settings/settings_view.dart';

import 'components/graph_list.dart';
import 'components/station_info.dart';

enum ConnectionState { notDownloaded, loading, finished }

class StationScreen extends StatefulWidget {
  final int index;
  const StationScreen(this.index, {Key? key}) : super(key: key);

  static const routeName = '/station';

  @override
  _StationScreenState createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  Station? _station;
  ConnectionState _connState = ConnectionState.notDownloaded;

  @override
  void initState() {
    super.initState();
    _getStation();
  }

  void _getStation() async {
    setState(() {
      _connState = ConnectionState.loading;
    });
    await StationList().init();
    Paths paths = Paths();
    final file = await paths.stationsFile;

    final contents = await file.readAsString();
    final List jsonStations = json.decode(contents);
    setState(() {
      _station = List.generate(jsonStations.length,
          (index) => Station.fromJson(jsonStations[index]))[widget.index];
      _connState = ConnectionState.finished;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_connState == ConnectionState.finished)
        ? Scaffold(
            appBar: AppBar(
              title: Text(_station!.name),
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
                    Navigator.restorablePushNamed(
                        context, SettingsView.routeName);
                  },
                ),
              ],
            ),
            body: SafeArea(
                child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                            flex: 4,
                            child: StationMap(station: _station!),
                          ),
                          Expanded(
                            flex: 1,
                            child: StationInfo(
                              index: widget.index,
                              station: _station!,
                            ),
                          ),
                        ]),
                        const StationGraphList(type: true, id: 2),
                        const StationGraphList(type: false, id: 2),
                      ],
                    ))))
        : Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(child: CircularProgressIndicator()));
  }
}
