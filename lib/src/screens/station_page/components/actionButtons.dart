import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/camera.dart';

import '../../../constant.dart';
import '../../../models/station.dart';
import '../../../models/user.dart';
import '../../../utils/connectDb.dart';
import '../../../utils/getSqlFunction.dart';
import 'employee_list.dart';
import 'find_repairer.dart';

class ButtonList extends StatefulWidget {
  final Station station;
  final User user;
  final int index;
  final MySqlConnection connection;
  const ButtonList(
      {Key? key,
      required this.station,
      required this.user,
      required this.index,
      required this.connection})
      : super(key: key);

  @override
  State<ButtonList> createState() => _ButtonListState();
}

class _ButtonListState extends State<ButtonList> {
  var db = Mysql();

  void _toggleReturn() async {
    String sql = await getCmd(widget.connection, 'Toggle return station');
    await widget.connection.query(sql, [widget.station.id]);
    setState(() {
      widget.station.returned = !widget.station.returned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!widget.station.state && widget.user.typeId == 1)
          InkWell(
            onTap: () => Navigator.restorablePushNamed(
                context, RepairerPage.routeName,
                arguments: <String, int>{'id': widget.station.id}),
            child: Row(children: [
              Text(
                'Send repairer',
                style: infoTextStyle(),
              ),
              const Icon(Icons.arrow_forward_ios_rounded)
            ]),
          ),
        if (widget.user.typeId != 4)
          InkWell(
            onTap: () => Navigator.restorablePushNamed(
                context, EmployeeListPage.routeName,
                arguments: <String, int>{'id': widget.station.id}),
            child: Row(
              children: [
                Text(
                  'Employee List',
                  style: infoTextStyle(),
                ),
                const Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
        if (widget.user.typeId != 4)
          InkWell(
            onTap: () {
              Navigator.restorablePushNamed(
                  context, LiveStreamingPlayer.routeName,
                  arguments: <String, int>{'index': widget.index});
            },
            child: Row(
              children: [
                Text(
                  'Security Camera',
                  style: infoTextStyle(),
                ),
                const Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
        if (widget.user.typeId != 4)
          Row(
            children: [
              widget.station.returned
                  ? Text(
                      'Energy arm returned',
                      style: boldTextStyle(color: Colors.red, size: 18.0),
                    )
                  : Text(
                      'Energy arm not returned',
                      style: boldTextStyle(color: Colors.green, size: 18.0),
                    ),
              IconButton(
                  onPressed: () => _toggleReturn(),
                  icon: Icon(widget.station.returned
                      ? Icons.toggle_on
                      : Icons.toggle_off_outlined))
            ],
          ),
      ],
    );
  }
}
