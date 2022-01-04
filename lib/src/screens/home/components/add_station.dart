// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/hashPw.dart';
import 'text_box.dart';

enum ConnectionState { NOT_DOWNLOADED, LOADING, FINISHED }

class AddStation extends StatefulWidget {
  final Function() notifyParrent;
  const AddStation({Key? key, required this.notifyParrent}) : super(key: key);

  @override
  _AddStationState createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {
  List<TextBox> stationBoxes = [
    TextBox(hintText: 'Name'),
    TextBox(
      hintText: 'Password',
      decorationPassword: true,
    ),
    TextBox(hintText: 'ManagerId'),
  ];
  var db = Mysql();
  String cmd = '';
  late MySqlConnection connection;
  ConnectionState _connState = ConnectionState.NOT_DOWNLOADED;

  @override
  void initState() {
    super.initState();
    setUpConn();
  }

  @override
  void dispose() {
    connection.close();
    super.dispose();
  }

  void setUpConn() async {
    setState(() {
      _connState = ConnectionState.LOADING;
    });
    MySqlConnection _connection = await db.getConn();
    setState(() {
      connection = _connection;
      _connState = ConnectionState.FINISHED;
    });
  }

  void addStation() async {
    String name = stationBoxes[0].controller.text;
    String password = stationBoxes[1].controller.text;
    String pwEncrypt = getEncrypt(password, name);
    String managerId = stationBoxes[2].controller.text;
    String sql = await getCmd();
    if (sql.isNotEmpty) {
      await connection.query(sql, [name, pwEncrypt, managerId]);
      widget.notifyParrent();
      Navigator.pop(context);
    }
  }

  Future<String> getCmd() async {
    String sql = '''SELECT sqlFunction FROM permission 
        WHERE permissionId IN 
          (SELECT permissionId FROM type_permission WHERE typeId = 1) 
        AND name = "Add station"''';
    var results = await connection.query(sql);
    for (var row in results) {
      cmd = row[0].toString().replaceAll('{}', '?');
    }
    return cmd;
  }

  @override
  Widget build(BuildContext context) {
    return (_connState == ConnectionState.FINISHED)
        ? AlertDialog(
            title: const Text('Station'),
            insetPadding: EdgeInsets.all(getScreenSize(context).height / 5),
            content: Form(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: stationBoxes,
            )),
            actions: [
              TextButton(
                onPressed: () => addStation(),
                child: const Text(
                  'Add',
                  style: infoTextStyle,
                ),
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
