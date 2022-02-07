import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/models/user.dart';

import '../state_container.dart';
import 'connectDb.dart';

Future<String> getCmd(BuildContext context, String cmdName) async {
  Mysql db = Mysql();
  late MySqlConnection connection;
  connection = await db.getConn();

  final container = StateContainer.of(context);
  User _user = container.user;
  int _typeId = _user.typeId;
  String cmd = '';
  String sql = '''SELECT sqlFunction FROM permission 
        WHERE permissionId IN 
          (SELECT permissionId FROM type_permission WHERE typeId = $_typeId) 
        AND name = "$cmdName"''';
  Results results = await connection.query(sql);
  if (results.isEmpty) {
    results = await connection.query(sql);
  }
  for (var row in results) {
    cmd = row[0].toString().replaceAll('{}', '?');
  }
  return cmd;
}
