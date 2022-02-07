import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/camera.dart';
import 'package:ocean_station_auto/src/state_container.dart';

import '../../../constant.dart';
import '../../../models/station.dart';
import '../../../models/user.dart';
import '../../../utils/connectDb.dart';
import '../../../utils/getSqlFunction.dart';
import '../../home/home_page.dart';
import 'employee_list.dart';
import 'find_repairer.dart';

class ButtonList extends StatefulWidget {
  final int index;
  final MySqlConnection connection;
  const ButtonList({Key? key, required this.index, required this.connection})
      : super(key: key);

  @override
  State<ButtonList> createState() => _ButtonListState();
}

class _ButtonListState extends State<ButtonList> {
  var db = Mysql();
  late Station _station;
  late User _user;

  void _exitStation() async {
    String sql = await getCmd(context, 'Exit station');
    await widget.connection.query(sql, [_user.id]);
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomePage.routeName,
      (_) => false,
    );
  }

  void _toggleState() async {
    String sql = await getCmd(context, 'Toggle state');
    await widget.connection.query(sql, [_station.id]);
    setState(() {
      _station.state = !_station.state;
    });
  }

  void _toggleReturn() async {
    String sql = await getCmd(context, 'Toggle return station');
    await widget.connection.query(sql, [_station.id]);
    setState(() {
      _station.returned = !_station.returned;
    });
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    _station = container.stationList[widget.index];
    _user = container.user;
    return Container(
        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
        padding: const EdgeInsets.all(18.0),
        decoration: roundedBorder(borderColor: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_station.state && _user.typeId == 1)
              Button(
                  title: 'Send repairer',
                  onPressed: () => Navigator.restorablePushNamed(
                      context, RepairerPage.routeName,
                      arguments: <String, int>{'id': _station.id}),
                  icon: const Icon(Icons.arrow_forward_ios_rounded)),
            if (_user.typeId != 4)
              Button(
                title: 'Employee List',
                onPressed: () => Navigator.restorablePushNamed(
                    context, EmployeeListPage.routeName,
                    arguments: <String, int>{'id': _station.id}),
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            if (_user.typeId != 4)
              Button(
                title: 'Security Camera',
                onPressed: () {
                  Navigator.restorablePushNamed(
                      context, LiveStreamingPlayer.routeName,
                      arguments: <String, int>{'index': widget.index});
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            if ([2, 3].contains(_user.typeId))
              !_station.state
                  ? Button(
                      title: 'Report fixed state',
                      onPressed: () => _toggleState(),
                      color: Colors.green,
                      icon: const Icon(Icons.done))
                  : Button(
                      title: 'Report bad state',
                      onPressed: () => _toggleState(),
                      color: Colors.red,
                      icon: const Icon(Icons.error_outline)),
            if (_user.typeId != 4)
              _station.returned
                  ? Button(
                      title: 'Energy arm returned',
                      onPressed: () => _toggleReturn(),
                      icon: const Icon(Icons.toggle_on),
                      color: Colors.green,
                    )
                  : Button(
                      title: 'Energy arm not returned',
                      onPressed: () => _toggleReturn(),
                      icon: const Icon(Icons.toggle_off_outlined),
                      color: Colors.red,
                    ),
            if (_user.typeId == 3 && _station.state)
              Button(
                  title: 'Exit station',
                  onPressed: () => _exitStation(),
                  color: Colors.red,
                  icon: const Icon(Icons.exit_to_app_rounded))
          ],
        ));
  }
}

class Button extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final Icon icon;
  final Color color;
  const Button(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.icon,
      this.color = Colors.white})
      : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: widget.color,
        side: BorderSide(color: widget.color),
      ),
      onPressed: () => widget.onPressed(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: boldTextStyle(size: 25.0),
          ),
          widget.icon,
        ],
      ),
    );
  }
}
