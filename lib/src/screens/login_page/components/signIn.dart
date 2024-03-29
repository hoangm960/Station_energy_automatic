import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/screens/home/home_page.dart';
import 'package:ocean_station_auto/src/screens/station_page/station_page.dart';
import 'package:ocean_station_auto/src/state_container.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/hashPw.dart';
import 'package:ocean_station_auto/src/screens/login_page/components/textBox.dart';

import '../../../models/location.dart';
import '../../../models/station.dart';
import '../../../utils/getSqlFunction.dart';

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
  late User _user;

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

  Future saveUser(id) async {
    String sql = '''SELECT u.name, displayName, t.name, t.typeId, u.stationId
            FROM user u
            LEFT JOIN type t USING (typeId)
            WHERE userId = $id''';
    var results = await connection.query(sql);
    if (results.isNotEmpty) {
      for (var row in results) {
        _user = User(
            id: id,
            username: row[0],
            displayName: row[1],
            type: row[2],
            typeId: row[3],
            stationId: row[4]);
        final container = StateContainer.of(context);
        container.updateUser(_user);
      }
    }
  }

  Future getStationList() async {
    final container = StateContainer.of(context);
    _user = container.user;
    List<Station> stations = [];
    String cmdName = '';

    if (_user.typeId == 1) {
      cmdName = "Get all stations data";
    } else {
      if (_user.stationId == null) {
        return [];
      }
      cmdName = "Get station data";
    }
    String sql = await getCmd(context, cmdName);
    if (sql.isNotEmpty) {
      var results = await connection.query(
          sql, _user.typeId != 1 ? [_user.stationId] : null);
      for (var row in results) {
        stations.add(Station(
            id: row[0],
            name: row[1],
            location: Location(x: row[2] ?? 0.0, y: row[3] ?? 0.0),
            voltDC: row[4] ?? 0.0,
            currentDC: row[5] ?? 0.0,
            voltAC: row[6] ?? 0.0,
            currentAC: row[7] ?? 0.0,
            power: row[8] ?? 0.0,
            energy: row[9] ?? 0.0,
            frequency: row[10] ?? 0.0,
            powerFactor: row[11] ?? 0.0,
            state: (row[12] == 1) ? true : false,
            returned: (row[13] == 1) ? true : false));
      }
    }
    if (stations.isNotEmpty) {
      container.updateStationList(stations);
    }
  }

  void checkData() async {
    String username = userBoxes[0].controller.text;
    String pw = getEncrypt(userBoxes[1].controller.text, username);
    String sql = 'SELECT userId, password FROM user WHERE name = "$username"';
    var results = await connection.query(sql);
    if (results.isNotEmpty) {
      for (var row in results) {
        if (pw == row[1]) {
          await saveUser(row[0]);
          await getStationList();
          connection.close();
          _user.stationId == null
              ? Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomePage.routeName,
                  (_) => false,
                )
              : Navigator.pushNamedAndRemoveUntil(
                  context, StationScreen.routeName, (_) => false,
                  arguments: <String, int>{'station': 0});
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
