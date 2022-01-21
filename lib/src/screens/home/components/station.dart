import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/user.dart';
import 'package:ocean_station_auto/src/screens/station_page/station_page.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:ocean_station_auto/src/utils/wind.dart';

class StationView extends StatefulWidget {
  final int index;
  final Station station;
  const StationView({Key? key, required this.index, required this.station})
      : super(key: key);

  @override
  State<StationView> createState() => _StationViewState();
}

class _StationViewState extends State<StationView> {
  late Timer timer;
  bool _alerted = false;
  double maxWindspeed = 10.0;
  late User _user;
  Mysql db = Mysql();
  late MySqlConnection connection;

  @override
  void initState() {
    super.initState();
    setUpConn();
    timer = Timer.periodic(const Duration(seconds: 20), _checkWindSpeed);
  }

  void setUpConn() async {
    MySqlConnection _connection = await db.getConn();
    setState(() {
      connection = _connection;
    });
    _user = await getUser();
  }

  void _checkWindSpeed(Timer timer) async {
    double windSpeed =
        await WeatherInfo(widget.station.location.x, widget.station.location.y)
            .getWindSpeed();
    _alerted = await _checkReturn();
    if (windSpeed > maxWindspeed && !_alerted) {
      _windAlert();
    }
  }

  Future<bool> _checkReturn() async {
    String sql = "SELECT returned FROM station WHERE stationId = ?";
    var results = await connection.query(sql, [widget.station.id]);
    if (results.isNotEmpty) {
      for (var row in results) {
        return row[0] == "1" ? true : false;
      }
    }
    return false;
  }

  void _returnSystem() async {
    String sql = await _getCmd();
    await connection.query(sql, [widget.station.id]);
  }

  Future<String> _getCmd() async {
    String cmd = '';
    String sql = '''SELECT sqlFunction FROM permission 
        WHERE permissionId IN 
          (SELECT permissionId FROM type_permission WHERE typeId = ?) 
        AND name = "Toggle return station"''';
    int typeId = _user.typeId;
    var results = await connection.query(sql, [typeId]);
    if (results.isNotEmpty) {
      for (var row in results) {
        cmd = row[0].toString().replaceAll('{}', '?');
      }
    }
    return cmd;
  }

  void _windAlert() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                '${widget.station.name} encountered overpowered wind (> 10 km/h). Please allow access to the returning system',
                style: infoTextStyle,
              ),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      _returnSystem();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('OK')),
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          Navigator.restorablePushNamed(context, StationScreen.routeName,
              arguments: <String, int>{'station': widget.index});
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.station.name,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Location: '),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(widget.station.location.x.toString()),
                      const VerticalDivider(
                        width: 5.0,
                      ),
                      Text(widget.station.location.y.toString()),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Power: '),
                  Text(widget.station.power.toString() + '(W)')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('State: '),
                  const SizedBox(
                    width: 38.0,
                  ),
                  widget.station.state
                      ? Row(
                          children: const [
                            Text(
                              'good',
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ],
                        )
                      : Row(
                          children: const [
                            Text(
                              'bad',
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.warning,
                              color: Colors.red,
                            ),
                          ],
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
