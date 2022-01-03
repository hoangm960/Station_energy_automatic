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
    db.setConn();
    connection = await db.conn;
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
    connection = await db.conn;

    List<Station> stations = [];
    String sql = await getCmd();
    if (sql.isNotEmpty) {
      var results = await connection.query(sql);
      for (var row in results) {
        stations.add(Station(
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
            state: (row[11] == 1) ? true : false));
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
