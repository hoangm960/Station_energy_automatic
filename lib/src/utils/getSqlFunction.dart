import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/user.dart';

Future<String> getCmd(MySqlConnection connection, String cmdName) async {
  User _user = await getUser();
  int _typeId = _user.typeId;
  String cmd = '';
  String sql = '''SELECT sqlFunction FROM permission 
        WHERE permissionId IN 
          (SELECT permissionId FROM type_permission WHERE typeId = $_typeId) 
        AND name = "$cmdName"''';
  var results = await connection.query(sql);
  if (results.isNotEmpty) {
    for (var row in results) {
      cmd = row[0].toString().replaceAll('{}', '?');
    }
  }
  return cmd;
}
