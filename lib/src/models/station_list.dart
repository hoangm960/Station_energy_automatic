import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/getSqlFunction.dart';

import 'location.dart';

class StationList {
  Mysql db = Mysql();
  late MySqlConnection connection;
  late List stationList;
  late User _user;
  List<Map> stationsJson = [];

  StationList();

  Future init() async {
    connection = await db.getConn();
    _user = await getUser();
    stationList = await getStationList();
    print(stationList);
    stationsJson = List.generate(
        stationList.length, (index) => stationList[index].toJson());
    await writeData(stationsJson);
  }

  Future writeData(var data) async {
    Paths paths = Paths();
    final file = await paths.stationsFile;
    file.writeAsString(json.encode(data));
  }

  Future getStationList() async {
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
    String sql = await getCmd(connection, cmdName);
    if (sql.isNotEmpty) {
      var results =
          await connection.query(sql, _user.typeId != 1 ? [_user.id] : null);
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
    return stations;
  }
}
