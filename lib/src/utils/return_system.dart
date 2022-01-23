import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';

late User _user;
Mysql db = Mysql();
late MySqlConnection connection;

void returnSystem(int id) async {
  connection = await db.getConn();
  _user = await getUser();

  String sql = await _getCmd();
  await connection.query(sql, [id]);
}

Future<String> _getCmd() async {
  String cmd = '';
  String sql = '''SELECT sqlFunction FROM permission 
        WHERE permissionId IN 
          (SELECT permissionId FROM type_permission WHERE typeId = ?) 
        AND name = "Toggle return station"''';
  int typeId = _user.typeId;
  var results = await connection.query(sql, [typeId]);
  if (results.isNotEmpty) {
    for (var row in results) {
      cmd = row[0].toString().replaceAll('{}', '?');
    }
  }
  return cmd;
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
