import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';

class StationList {
  Mysql db = Mysql();
  late Future<MySqlConnection> connection;
  List<Station> stationList = [];
  StationList();

  List<Station> getData() {
    connection = db.conn;
    connection.then((connection) {
      String sql = 'SELECT * FROM station WHERE stationId = 2';
      connection.query(sql).then((results) {
        for (var row in results) {
          stationList.add(Station(
              name: row[1],
              location: Location(x: 16, y: 18),
              voltDC: row[4],
              currentDC: row[5],
              voltAC: row[6],
              currentAC: row[7],
              power: row[8],
              energy: row[9],
              frequency: row[10],
              powerFactor: row[11],
              state: row[12]));
        }
      });
      connection.close();
    });
    return stationList;
  }
}
