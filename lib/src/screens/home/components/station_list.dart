import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station_list.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/screens/home/components/station.dart';

class StationListView extends StatefulWidget {
  const StationListView({Key? key}) : super(key: key);

  @override
  _StationListViewState createState() => _StationListViewState();
}

class _StationListViewState extends State<StationListView> {
  Future<List<Station>> _getStation() async {
    await StationList().init();
    Paths paths = Paths();
    final file = await paths.stationsFile;

    final contents = await file.readAsString();
    final List jsonStations = json.decode(contents);
    return List.generate(
        jsonStations.length, (index) => Station.fromJson(jsonStations[index]));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Station>>(
        future: _getStation(),
        builder: (BuildContext context, AsyncSnapshot<List<Station>> snapshot) {
          return GridView.extent(
            maxCrossAxisExtent: 300,
            padding: const EdgeInsets.all(10.0),
            children: snapshot.hasData
                ? List.generate(
                    snapshot.data!.length,
                    (index) => StationView(
                        index: index, station: snapshot.data![index]))
                : [const Center(child: CircularProgressIndicator())],
          );
        });
  }
}
