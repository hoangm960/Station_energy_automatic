import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';

enum ConnectionState { notDownloaded, loading, finished }

class RepairerPage extends StatefulWidget {
  final int stationId;
  const RepairerPage({Key? key, required this.stationId}) : super(key: key);

  static const routeName = '/repairer';

  @override
  _RepairerPageState createState() => _RepairerPageState();
}

class _RepairerPageState extends State<RepairerPage> {
  String dropdownValue = 'One';
  var db = Mysql();
  late MySqlConnection connection;
  ConnectionState _connState = ConnectionState.notDownloaded;
  List<User> repairerList = [];

  @override
  void initState() {
    super.initState();
    setUpConn();
  }

  void setUpConn() async {
    setState(() {
      _connState = ConnectionState.loading;
    });
    MySqlConnection _connection = await db.getConn();
    setState(() {
      connection = _connection;
    });
    Future.delayed(const Duration(seconds: 1), () => _getRepairer());
  }

  Future<String> _getCmd(cmdName) async {
    String cmd = '';
    String sql = '''SELECT sqlFunction FROM permission 
        WHERE permissionId IN 
          (SELECT permissionId FROM type_permission WHERE typeId = ?) 
        AND name = "$cmdName"''';
    User _user = await getUser();
    var results = await connection.query(sql, [_user.typeId]);
    for (var row in results) {
      cmd = row[0].toString().replaceAll('{}', '?');
    }
    return cmd;
  }

  void _getRepairer() async {
    String sql = await Future.value(_getCmd('Get all repairers'));
    List<User> _repairerList = [];
    if (sql.isNotEmpty) {
      var results = await connection.query(sql);
      for (var row in results) {
        if (mounted) {
          _repairerList.add(User(
              id: row[0],
              username: row[1],
              displayName: row[2],
              type: 'Repairer',
              typeId: 3));
          setState(() {
            repairerList = _repairerList;
            _connState = ConnectionState.finished;
          });
        }
      }
    }
  }

  void _assignRepairer(userId) async {
    String sql = await Future.value(_getCmd('Assign repair'));
    await connection.query(sql, [widget.stationId, userId]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Repairer'),
      ),
      body: (_connState == ConnectionState.finished)
          ? ListView.builder(
              itemCount: repairerList.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 80.0,
                  child: InkWell(
                    onTap: () {
                      _assignRepairer(repairerList[index].id);
                      Navigator.pop(context);
                    },
                    child: Card(
                      margin: const EdgeInsetsDirectional.all(10.0),
                      elevation: 5.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                'ID: ${repairerList[index].id}',
                                style: boldTextStyle,
                              )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                'Username: ${repairerList[index].username}',
                                style: boldTextStyle,
                              )),
                          Expanded(
                              flex: 3,
                              child: Text(
                                'Display name: ${repairerList[index].displayName}',
                                style: boldTextStyle,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
