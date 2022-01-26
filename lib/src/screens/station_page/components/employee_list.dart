import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/getSqlFunction.dart';
import 'package:ocean_station_auto/src/utils/wind.dart';

enum ConnectionState { notDownloaded, loading, finished }

class EmployeeListPage extends StatefulWidget {
  final int stationId;
  const EmployeeListPage({Key? key, required this.stationId}) : super(key: key);

  static const routeName = '/employeeList';

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  String dropdownValue = 'One';
  var db = Mysql();
  late MySqlConnection connection;
  ConnectionState _connState = ConnectionState.notDownloaded;
  List<User> employeeList = [];
  late Timer timer;

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
    Future.delayed(const Duration(seconds: 1), () => _getEmployees());
    setUpCheckWind();
  }

  void setUpCheckWind() async {
    Station _station = await getStation(0);
    timer = Timer.periodic(const Duration(seconds: 20),
        (Timer timer) => checkWindSpeed(connection, context, _station));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _getEmployees() async {
    String sql = await Future.value(getCmd(connection, 'Get all employees'));
    List<User> _employeeList = [];
    if (sql.isNotEmpty) {
      var results = await connection.query(sql, [widget.stationId]);
      for (var row in results) {
        if (mounted) {
          _employeeList.add(User(
              id: row[0],
              username: row[1],
              displayName: row[2],
              type: row[3],
              typeId: row[4]));
          setState(() {
            employeeList = _employeeList;
            _connState = ConnectionState.finished;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: (_connState == ConnectionState.finished)
          ? ListView.builder(
              itemCount: employeeList.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 80.0,
                  child: Card(
                    margin: const EdgeInsetsDirectional.all(10.0),
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              'ID: ${employeeList[index].id}',
                              style: boldTextStyle(),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              'Username: ${employeeList[index].username}',
                              style: boldTextStyle(),
                            )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Display name: ${employeeList[index].displayName}',
                              style: boldTextStyle(),
                            )),
                      ],
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
