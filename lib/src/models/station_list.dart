import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';

class StationList {
  Mysql db = Mysql();
  late Future<MySqlConnection> connection;
  List<Station> stationList = [];
  StationList();

  void getData() {
    db.setConn();
    connection = db.conn;
    connection.then((connection) {
      String sql =
          'SELECT name, ST_X(Location), ST_Y(location), voltDC, currentDC, voltAC, currentAC, powerAC, energyAC, energyAC, frequencyAC, powerfactorAC, state FROM station WHERE stationId = 2';
      connection.query(sql).then((results) {
        print(results);
      });

      // for (var row in results) {
      //   // ignore: unnecessary_this
      //   this.stationList.add(Station(
      //       name: row[0],
      //       location: Location(x: row[1], y: row[2]),
      //       voltDC: row[3],
      //       currentDC: row[4],
      //       voltAC: row[5],
      //       currentAC: row[6],
      //       power: row[7],
      //       energy: row[8],
      //       frequency: row[9],
      //       powerFactor: row[10],
      //       state: row[11]));
      // }
      // await connection.close();
    });
  }
}
