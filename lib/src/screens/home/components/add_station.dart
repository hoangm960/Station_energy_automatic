import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/hashPw.dart';
import 'text_box.dart';

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

  @override
  void initState() {
    super.initState();
    db.setConn();
  }

  void addStation() async {
    String name = stationBoxes[0].controller.text;
    String password = stationBoxes[1].controller.text;
    String pwEncrypt = getEncrypt(password, name);
    String managerId = stationBoxes[2].controller.text;
    String sql = await getCmd();
    if (sql.isNotEmpty) {
      connection = await db.conn;
      await connection.query(sql, [name, pwEncrypt, managerId]);
      connection.close();
      widget.notifyParrent;
      Navigator.pop(context);
    }
  }

  Future<String> getCmd() async {
    connection = await db.conn;

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
    return AlertDialog(
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
    );
  }
}
