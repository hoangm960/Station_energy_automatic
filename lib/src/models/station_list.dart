import 'dart:convert';
import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';

import 'location.dart';

class StationList {
  Mysql db = Mysql();
  late MySqlConnection connection;
  late List<Station> stationList;
  late User _user;

  StationList();

  Future init() async {
    connection = await db.getConn();
    _user = await getUser();
    stationList = await getStationList();
    List<Map> stationsJson = List.generate(
        stationList.length, (index) => stationList[index].toJson());
    writeData(stationsJson);
  }

  Future<File> writeData(var data) async {
    Paths paths = Paths();
    final file = await paths.stationsFile;

    return file.writeAsString(json.encode(data));
  }

  Future getUser() async {
    Paths paths = Paths();
    final file = await paths.userFile;

    final contents = await file.readAsString();
    final Map<String, dynamic> jsonUser = json.decode(contents);
    return User.fromJson(jsonUser);
  }

  Future getStationList() async {
    List<Station> stations = [];
    String sql = await getCmd();
    if (sql.isNotEmpty) {
      var results = await connection.query(sql);
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
            state: (row[12] == 1) ? true : false));
      }
    }
    return stations;
  }

  Future<String> getCmd() async {
    String cmd = '';
    String sql = '''SELECT sqlFunction FROM permission 
        WHERE permissionId IN
          (SELECT permissionId FROM type_permission WHERE typeId = 1)
        AND name = "Get all stations data"''';
    var results = await connection.query(sql);
    for (var row in results) {
      cmd = row[0];
    }
    return cmd;
  }
}
