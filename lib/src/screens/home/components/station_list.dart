import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/screens/home/components/station.dart';

import '../../../state_container.dart';
class StationListView extends StatefulWidget {
  const StationListView({Key? key}) : super(key: key);

  @override
  _StationListViewState createState() => _StationListViewState();
}

class _StationListViewState extends State<StationListView> {
  late List<Station> _stations;

  @override
  Widget build(BuildContext context) {
    _stations = StateContainer.of(context).stationList;
    if (_stations.isNotEmpty) {
      return GridView.extent(
          maxCrossAxisExtent: 300,
          padding: const EdgeInsets.all(10.0),
          children: List.generate(_stations.length,
              (index) => StationView(index: index, station: _stations[index])));
    } else {
      return Center(
        child: Text(
          'No assigned station',
          style: infoTextStyle(),
        ),
      );
    }
  }
}
