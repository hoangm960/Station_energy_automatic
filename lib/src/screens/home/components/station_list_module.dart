import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station_list.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/screens/station_page/station_page.dart';

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

  Widget _buildStationCard(int index, Station station) {
    return Card(
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          Navigator.restorablePushNamed(context, StationScreen.routeName,
              arguments: <String, int>{'station': index});
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                station.name,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Location: '),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(station.location.x.toString()),
                      const VerticalDivider(
                        width: 5.0,
                      ),
                      Text(station.location.y.toString()),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Power: '),
                  Text(station.power.toString() + '(W)')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('State: '),
                  const SizedBox(
                    width: 38.0,
                  ),
                  station.state
                      ? Row(
                          children: const [
                            Text(
                              'good',
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ],
                        )
                      : Row(
                          children: const [
                            Text(
                              'bad',
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.warning,
                              color: Colors.red,
                            ),
                          ],
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Station>>(
      future: _getStation(),
      builder: (BuildContext context, AsyncSnapshot<List<Station>> snapshot) {
        return GridView.extent(
          maxCrossAxisExtent: 300,
          padding: const EdgeInsets.all(10.0),
          children: snapshot.hasData ? List.generate(snapshot.data!.length,
              (index) => _buildStationCard(index, snapshot.data![index])) : [const Center(child: CircularProgressIndicator())],
        );
      }
    );
  }
}
