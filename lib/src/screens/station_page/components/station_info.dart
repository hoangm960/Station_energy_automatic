// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/location.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/camera.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/find_repairer.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';

enum ConnectionState { NOT_DOWNLOADED, LOADING, FINISHED }

class StationInfo extends StatefulWidget {
  final int index;
  final Station station;
  const StationInfo({Key? key, required this.index, required this.station})
      : super(key: key);

  @override
  State<StationInfo> createState() => _StationInfoState();
}

class _StationInfoState extends State<StationInfo> {
  String dropdownValue = 'One';
  var db = Mysql();
  late MySqlConnection connection;
  late Timer timer;
  late Station _station;
  ConnectionState _connState = ConnectionState.NOT_DOWNLOADED;

  @override
  void initState() {
    super.initState();
    setUpConn();
    _station = widget.station;
  }

  void setUpConn() async {
    setState(() {
      _connState = ConnectionState.LOADING;
    });
    MySqlConnection _connection = await db.getConn();
    setState(() {
      connection = _connection;
      _connState = ConnectionState.FINISHED;
    });
    timer = Timer.periodic(const Duration(seconds: 5), _getParam);
  }

  void _getParam(Timer timer) async {
    String sql = await _getCmd();
    var results = await connection.query(sql, [widget.station.id]);
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
              state: (row[12] == 1) ? true : false);
        });
      }
    }
  }

  Future<String> _getCmd() async {
    String cmd = '';
    String sql = '''SELECT sqlFunction FROM permission 
        WHERE permissionId IN 
          (SELECT permissionId FROM type_permission WHERE typeId IN (1,2)) 
        AND name = "Get station data"''';
    var results = await connection.query(sql);
    for (var row in results) {
      cmd = row[0].toString().replaceAll('{}', '?');
    }
    return cmd;
  }

  @override
  Widget build(BuildContext context) {
    return (_connState == ConnectionState.FINISHED)
        ? Container(
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
                    'VoltDC: ${_station.voltDC.toStringAsFixed(2)} V',
                    style: infoTextStyle,
                  ),
                  Text(
                    'CurrentDC: ${_station.currentDC.toStringAsFixed(2)} A',
                    style: infoTextStyle,
                  ),
                  Text(
                    'VoltAC: ${_station.voltAC.toStringAsFixed(2)} V',
                    style: infoTextStyle,
                  ),
                  Text(
                    'CurrentAC: ${_station.currentAC.toStringAsFixed(2)} A',
                    style: infoTextStyle,
                  ),
                  Text(
                    'Power: ${_station.power.toStringAsFixed(2)} W',
                    style: infoTextStyle,
                  ),
                  Text(
                    'Energy: ${_station.energy.toStringAsFixed(2)} kW/h',
                    style: infoTextStyle,
                  ),
                  Text(
                    'Frequency: ${_station.frequency.toStringAsFixed(2)} Hz',
                    style: infoTextStyle,
                  ),
                  Text(
                    'Power Factor: ${_station.powerFactor.toStringAsFixed(2)}',
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
                  if (!_station.state)
                    InkWell(
                      onTap: () => Navigator.restorablePushNamed(
                          context, RepairerPage.routeName, arguments: <String, int>{'id': _station.id}),
                      child: Row(children: const [
                        Text(
                          'Send repairer',
                          style: infoTextStyle,
                        ),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ]),
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
                          arguments: <String, int>{'index': widget.index});
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
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
