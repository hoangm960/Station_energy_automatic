import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/utils/getSqlFunction.dart';

void returnSystem(MySqlConnection connection, int id) async {
  String sql = await getCmd(connection, "Toggle return station");
  await connection.query(sql, [id]);
}

Future<bool> checkReturn(MySqlConnection connection, int id) async {
  String sql = "SELECT returned FROM station WHERE stationId = ?";
  var results = await connection.query(sql, [id]);
  if (results.isNotEmpty) {
    for (var row in results) {
      return row[0] == "1" ? true : false;
    }
  }
  return false;
}
