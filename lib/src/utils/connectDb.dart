import 'dart:async';
import 'package:mysql1/mysql1.dart';

class Mysql {
  var conn;

  Mysql();
  void setConn() async {
    
    // ignore: unnecessary_this
    this.conn =  MySqlConnection.connect(ConnectionSettings(
        host: 'khktdb.ddns.net',
        port: 3306,
        user: 'root',
        db: 'khkt_sql',
        password: 'KhktNH123@@'));
  }
}
