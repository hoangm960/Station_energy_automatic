import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/screens/profile_page.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/map.dart';
import 'package:ocean_station_auto/src/settings/settings_view.dart';
import 'package:ocean_station_auto/src/state_container.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/wind.dart';

import '../../models/location.dart';
import '../../utils/getSqlFunction.dart';
import 'components/actionButtons.dart';
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
  late Timer windTimer;
  late Timer stationTimer;
  var db = Mysql();
  late MySqlConnection connection;

  @override
  void initState() {
    super.initState();
    setUpConn();
  }

  @override
  void dispose() {
    windTimer.cancel();
    stationTimer.cancel();
    super.dispose();
  }

  void _setUpCheckWind() {
    final container = StateContainer.of(context);

    Station _station = container.stationList[0];
    windTimer = Timer.periodic(const Duration(seconds: 20),
        (Timer timer) => checkWindSpeed(connection, context, _station));
  }

  void _getParam(Timer timer) async {
    final container = StateContainer.of(context);
    String sql = await getCmd(context, "Get station data");
    var results = await connection.query(sql, [_station!.id]);
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
        List<Station> _stations = container.stationList;
        _stations[widget.index] = _station!;
        container.updateStationList(_stations);
      }
    }
  }

  Future setUpConn() async {
    setState(() {
      _connState = ConnectionState.loading;
    });
    MySqlConnection _connection = await db.getConn();
    setState(() {
      connection = _connection;
    });
    final container = StateContainer.of(context);

    _station = container.stationList[widget.index];
    _setUpCheckWind();
    setState(() {
      _connState = ConnectionState.finished;
    });
    stationTimer = Timer.periodic(const Duration(seconds: 5), _getParam);
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    _station = container.stationList[widget.index];
    return (_connState == ConnectionState.finished)
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                _station!.name,
                style: boldTextStyle(size: 25.0),
              ),
              centerTitle: true,
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
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 20.0, 10.0),
                              decoration:
                                  roundedBorder(borderColor: Colors.white),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: StationMap(index: widget.index, station: _station!,),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: StationInfo(
                                      index: widget.index,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ButtonList(
                                connection: connection, index: widget.index),
                          ),
                        ]),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(children: [
                      Expanded(
                        child: Container(
                            margin:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                            decoration: roundedBorder(borderColor: Colors.white),
                            child: StationGraphList(
                              type: true,
                              index: widget.index,
                            )),
                      ),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                          decoration: roundedBorder(borderColor: Colors.white),
                          child: StationGraphList(
                            type: false,
                            index: widget.index,
                          ),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(child: CircularProgressIndicator()));
  }
}
