import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station_list.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/screens/home/components/station.dart';

enum ConnectionState { notDownloaded, loading, finished }

class StationListView extends StatefulWidget {
  const StationListView({Key? key}) : super(key: key);

  @override
  _StationListViewState createState() => _StationListViewState();
}

class _StationListViewState extends State<StationListView> {
  late List<Station> _stations;
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
    if (contents.isNotEmpty) {
      final List jsonStations = json.decode(contents);
      setState(() {
        _stations = List.generate(jsonStations.length,
            (index) => Station.fromJson(jsonStations[index]));
        _connState = ConnectionState.finished;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_connState == ConnectionState.finished)
        ? (_stations.isNotEmpty)
            ? GridView.extent(
                maxCrossAxisExtent: 300,
                padding: const EdgeInsets.all(10.0),
                children: List.generate(
                    _stations.length,
                    (index) =>
                        StationView(index: index, station: _stations[index])))
            : Center(
                child: Text(
                  'No assigned station',
                  style: infoTextStyle(),
                ),
              )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
