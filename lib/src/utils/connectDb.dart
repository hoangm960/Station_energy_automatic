import 'dart:async';

import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'khktdb.ddns.net',
      user = 'minh',
      db = 'khkt_sql',
      password = 'nhatminhb5/2901';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}
