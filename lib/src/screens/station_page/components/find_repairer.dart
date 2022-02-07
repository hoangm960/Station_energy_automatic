import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/getSqlFunction.dart';

enum ConnectionState { notDownloaded, loading, finished }

class RepairerPage extends StatefulWidget {
  final int stationId;
  const RepairerPage({Key? key, required this.stationId}) : super(key: key);

  static const routeName = '/repairer';

  @override
  _RepairerPageState createState() => _RepairerPageState();
}

class _RepairerPageState extends State<RepairerPage> {
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

  void _getRepairer() async {
    String sql = await Future.value(getCmd(context, 'Get all repairers'));
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
        }
      }
      setState(() {
        repairerList = _repairerList;
        _connState = ConnectionState.finished;
      });
    }
  }

  void _assignRepairer(userId) async {
    String sql = await getCmd(context, 'Assign repair');
    await connection.query(sql, [widget.stationId, userId]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repairers List'),
      ),
      body: (_connState == ConnectionState.finished)
          ? GridView.extent(
              maxCrossAxisExtent: 350,
              padding: const EdgeInsets.all(10.0),
              children: List.generate(
                repairerList.length,
                (index) {
                  return Card(
                      elevation: 5.0,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: InkWell(
                          onTap: () {
                            _assignRepairer(repairerList[index].id);
                            Navigator.pop(context);
                          },
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
                                'ID: ${repairerList[index].id}',
                                style: boldTextStyle(size: 20.0),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                repairerList[index].displayName,
                                style: boldTextStyle(size: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
