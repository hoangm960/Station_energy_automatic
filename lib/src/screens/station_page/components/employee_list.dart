import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/getSqlFunction.dart';

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
  }

  void _getEmployees() async {
    String sql = await Future.value(getCmd(context, 'Get all employees'));
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

  Color _getColor(typeId) {
    switch (typeId) {
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: (_connState == ConnectionState.finished)
          ? GridView.extent(
              maxCrossAxisExtent: 350,
              padding: const EdgeInsets.all(10.0),
              children: List.generate(
                employeeList.length,
                (index) {
                  return Container(
                    decoration: BoxDecoration(border: Border.all(color: _getColor(employeeList[index].typeId), width: 10.0)),
                    child: Card(
                      elevation: 5.0,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              child: Icon(
                                Icons.person,
                                size: 50.0,
                              ),
                              radius: 35.0,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'ID: ${employeeList[index].id}',
                              style: boldTextStyle(size: 20.0),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              employeeList[index].displayName,
                              style: boldTextStyle(size: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
