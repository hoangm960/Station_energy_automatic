import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/getSqlFunction.dart';

Mysql db = Mysql();
late MySqlConnection connection;

void returnSystem(int id) async {
  connection = await db.getConn();

  String sql = await getCmd(connection, "Toggle return station");
  await connection.query(sql, [id]);
}

Future<bool> checkReturn(int id) async {
  String sql = "SELECT returned FROM station WHERE stationId = ?";
  var results = await connection.query(sql, [id]);
  if (results.isNotEmpty) {
    for (var row in results) {
      return row[0] == "1" ? true : false;
    }
  }
  return false;
}
