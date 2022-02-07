import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/screens/home/components/station.dart';

import '../../../models/location.dart';
import '../../../models/user.dart';
import '../../../state_container.dart';
import '../../../utils/connectDb.dart';
import '../../../utils/getSqlFunction.dart';

enum ConnectionState { notDownloaded, loading, finished }

class StationListView extends StatefulWidget {
  const StationListView({Key? key}) : super(key: key);

  @override
  _StationListViewState createState() => _StationListViewState();
}

class _StationListViewState extends State<StationListView> {
  List<Station> _stations = [];
  ConnectionState _connState = ConnectionState.notDownloaded;
  Mysql db = Mysql();
  late MySqlConnection connection;
  late User _user;

  @override
  void initState() {
    super.initState();
    _getStations();
  }

  Future _getStations() async {
    setState(() {
      _connState = ConnectionState.loading;
    });
    connection = await db.getConn();
    await getStationList();
    setState(() {
      _connState = ConnectionState.finished;
    });
  }

  Future getStationList() async {
    final container = StateContainer.of(context);
    _user = container.user;
    List<Station> stations = [];
    String cmdName = '';

    if (_user.typeId == 1) {
      cmdName = "Get all stations data";
    } else {
      if (_user.stationId == null) {
        return [];
      }
      cmdName = "Get station data";
    }
    String sql = await getCmd(context, cmdName);
    if (sql.isNotEmpty) {
      var results = await connection.query(
          sql,
          _user.typeId != 1 ? [_user.stationId] : null);
      for (var row in results) {
        stations.add(Station(
            id: row[0],
            name: row[1],
            location: Location(x: row[2] ?? 0.0, y: row[3] ?? 0.0),
            voltDC: row[4] ?? 0.0,
            currentDC: row[5] ?? 0.0,
            voltAC: row[6] ?? 0.0,
            currentAC: row[7] ?? 0.0,
            power: row[8] ?? 0.0,
            energy: row[9] ?? 0.0,
            frequency: row[10] ?? 0.0,
            powerFactor: row[11] ?? 0.0,
            state: (row[12] == 1) ? true : false,
            returned: (row[13] == 1) ? true : false));
      }
    }
    if (stations.isNotEmpty) {
      container.updateStationList(stations);
      setState(() {
        _stations = stations;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connState == ConnectionState.finished) {
      if (_stations.isNotEmpty) {
        return GridView.extent(
            maxCrossAxisExtent: 300,
            padding: const EdgeInsets.all(10.0),
            children: List.generate(
                _stations.length,
                (index) =>
                    StationView(index: index, station: _stations[index])));
      } else {
        return Center(
          child: Text(
            'No assigned station',
            style: infoTextStyle(),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
