import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/location.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/utils/getSqlFunction.dart';

class StationInfo extends StatefulWidget {
  final int index;
  final User user;
  final MySqlConnection connection;
  final Station station;
  const StationInfo(
      {Key? key,
      required this.index,
      required this.user,
      required this.station,
      required this.connection})
      : super(key: key);

  @override
  State<StationInfo> createState() => _StationInfoState();
}

class _StationInfoState extends State<StationInfo> {
  late Timer timer;
  late Station _station;

  @override
  void initState() {
    super.initState();
    _station = widget.station;
    timer = Timer.periodic(const Duration(seconds: 5), _getParam);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _getParam(Timer timer) async {
    String sql = await getCmd(widget.connection, "Get station data");
    var results = await widget.connection.query(sql, [widget.station.id]);
    for (var row in results) {
      if (mounted) {
        setState(() {
          _station = Station(
              id: row[0],
              name: row[1],
              location: Location(x: row[2], y: row[3]),
              voltDC: row[4],
              currentDC: row[5],
              voltAC: row[6],
              currentAC: row[7],
              power: row[8],
              energy: row[9],
              frequency: row[10],
              powerFactor: row[11],
              state: (row[12] == 1) ? true : false,
              returned: (row[13] == 1) ? true : false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 8.0, 8.0),
      padding: const EdgeInsets.all(18.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Status(state: _station.state),
            Text(
              'Location: ${_station.location.x} ${_station.location.y}',
              style: infoTextStyle(size: 20.0),
            ),
            Text(
              'Power: ${_station.power.toStringAsFixed(2)} W',
              style: infoTextStyle(size: 20.0),
            ),
          ]),
    );
  }
}

class Status extends StatelessWidget {
  final bool state;
  const Status({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: roundedBorder(color: state ? Colors.green : Colors.red),
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Text(
          state ? 'Good' : 'Bad',
          style: boldTextStyle(size: 40.0),
        ),
      ),
    );
  }
}
