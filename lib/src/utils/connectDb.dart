import 'package:mysql1/mysql1.dart';


class Mysql {
  Future<MySqlConnection> getConn() async {
    return await MySqlConnection.connect(ConnectionSettings(
        host: 'khktdb.ddns.net',
        port: 3306,
        user: 'root',
        db: 'khkt_sql',
        password: 'KhktNH123@@'));
  }
}
