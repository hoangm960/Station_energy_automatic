import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/map.dart';

import 'components/graph_list.dart';
import 'components/station_info.dart';

class StationScreen extends StatefulWidget {
  final int index;
  const StationScreen(this.index, {Key? key}) : super(key: key);

  static const routeName = '/station';

  @override
  _StationScreenState createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  Station? station;

  @override
  void initState() {
    super.initState();
    station = stationList[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(station!.name),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),

                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                        flex: 4,
                        child: StationMap(station: station!),
                      ),
                      Expanded(
                        flex: 1,
                        child: StationInfo(
                          station: station!,
                        ),
                      ),
                    ]),
                    const StationGraphList(title: 'Output DC:'),
                    const StationGraphList(title: 'Output AC:'),
                  ],
                ))));
  }
}
