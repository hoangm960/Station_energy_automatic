import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/screens/home/home_page.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/hashPw.dart';
import 'package:ocean_station_auto/src/screens/login_page/components/textBox.dart';
import 'package:ocean_station_auto/src/constant.dart';

enum ConnectionState { notDownloaded, loading, finished }

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool hidePassword = true;
  List<TextBox> userBoxes = [
    TextBox(hintText: 'Username'),
    TextBox(
      hintText: 'Password',
      decorationPassword: true,
    )
  ];
  var db = Mysql();
  late MySqlConnection connection;
  Color borderColor = Colors.transparent;
  ConnectionState _connState = ConnectionState.notDownloaded;

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
      _connState = ConnectionState.finished;
    });
  }

  Future<File> writeData(var data) async {
    Paths paths = Paths();
    final file = await paths.userFile;

    return file.writeAsString(json.encode(data));
  }

  void saveUser(id) async {
    String sql = '''SELECT u.name, displayName, t.name, t.typeId, u.stationId
            FROM user u
            LEFT JOIN type t USING (typeId)
            WHERE userId = $id''';
    var results = await connection.query(sql);
    if (results.isNotEmpty) {
      for (var row in results) {
        Map userData = User(
                id: id,
                username: row[0],
                displayName: row[1],
                type: row[2],
                typeId: row[3],
                stationId: row[4])
            .toJson();
        writeData(userData);
      }
    }
    connection.close();
  }

  void checkData() {
    String username = userBoxes[0].controller.text;
    String pw = getEncrypt(userBoxes[1].controller.text, username);
    String sql = 'SELECT userId, password FROM user WHERE name = "$username"';
    connection.query(sql).then((value) {
      if (value.isNotEmpty) {
        for (var row in value) {
          if (pw == row[1]) {
            saveUser(row[0]);
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (_) => false);
          } else {
            setState(() {
              borderColor = Colors.redAccent;
            });
          }
        }
      } else {
        setState(() {
          borderColor = Colors.redAccent;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_connState == ConnectionState.finished)
        ? Column(
            children: <Widget>[
              const SizedBox(
                height: 60,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 20,
                          offset: Offset(0, 10))
                    ]),
                child: Column(children: userBoxes),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () => checkData(),
                child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.orange[900]),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
