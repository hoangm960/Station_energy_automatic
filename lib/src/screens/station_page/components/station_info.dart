import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/camera.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';

class StationInfo extends StatefulWidget {
  final int index;
  const StationInfo({Key? key, required this.index}) : super(key: key);

  @override
  State<StationInfo> createState() => _StationInfoState();
}

class _StationInfoState extends State<StationInfo> {
  String dropdownValue = 'One';
  var db = Mysql();
  late Future<MySqlConnection> connection;
  late Timer timer;
  late Station _station;

  void _getParam(Timer timer) async {
    connection.then((connection) {
      String sql =
          'SELECT name, ST_X(Location), ST_Y(location), voltDC, currentDC, voltAC, currentAC, powerAC, energyAC, frequencyAC, powerfactorAC, state FROM station';
      connection.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            _station = Station(
                name: row[0],
                location: Location(x: row[1], y: row[2]),
                voltDC: row[3],
                currentDC: row[4],
                voltAC: row[5],
                currentAC: row[6],
                power: row[7],
                energy: row[8],
                frequency: row[9],
                powerFactor: row[10],
                state: (row[11] == 1) ? true : false);
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), _getParam);
    db.setConn();
    connection = db.conn;
    _station = stationList[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenSize(context).height - 18.0 * 2,
      padding: const EdgeInsets.all(18.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Location: ${_station.location.x} ${_station.location.y}',
              style: infoTextStyle,
            ),
            Text(
              'VoltDC: ${_station.voltDC} V',
              style: infoTextStyle,
            ),
            Text(
              'CurrentDC: ${_station.currentDC} A',
              style: infoTextStyle,
            ),
            Text(
              'VoltAC: ${_station.voltAC} V',
              style: infoTextStyle,
            ),
            Text(
              'CurrentAC: ${_station.currentAC} A',
              style: infoTextStyle,
            ),
            Text(
              'Power: ${_station.power} W',
              style: infoTextStyle,
            ),
            Text(
              'Energy: ${_station.energy} kW/h',
              style: infoTextStyle,
            ),
            Text(
              'Frequency: ${_station.frequency} Hz',
              style: infoTextStyle,
            ),
            Text(
              'Power Factor: ${_station.powerFactor}',
              style: infoTextStyle,
            ),
            Center(
              child: Row(
                children: [
                  const Text(
                    'State: ',
                    style: infoTextStyle,
                  ),
                  _station.state
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
                        ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: const [
                  Text(
                    'Employee List',
                    style: infoTextStyle,
                  ),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.restorablePushNamed(
                    context, LiveStreamingPlayer.routeName,
                    arguments: <String, String>{
                      'url': 'https://www.youtube.com/embed/fEZcqfNGiQg'
                    });
              },
              child: Row(
                children: const [
                  Text(
                    'Security Camera',
                    style: infoTextStyle,
                  ),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            )
          ]),
    );
  }
}
