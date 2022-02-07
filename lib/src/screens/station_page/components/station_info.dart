import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/user.dart';

class StationInfo extends StatefulWidget {
  final int index;
  final User user;
  final Station station;
  const StationInfo(
      {Key? key,
      required this.index,
      required this.user,
      required this.station})
      : super(key: key);

  @override
  State<StationInfo> createState() => _StationInfoState();
}

class _StationInfoState extends State<StationInfo> {
  late Station _station;

  @override
  void initState() {
    super.initState();
    _station = widget.station;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 8.0, 8.0),
      padding: const EdgeInsets.all(18.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Status(state: _station.state),
            Text(
              'Location: ${_station.location.x} ${_station.location.y}',
              style: infoTextStyle(size: 20.0),
            ),
            Text(
              'Power: ${_station.power.toStringAsFixed(2)} W',
              style: infoTextStyle(size: 20.0),
            ),
          ]),
    );
  }
}

class Status extends StatelessWidget {
  final bool state;
  const Status({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: roundedBorder(color: state ? Colors.green : Colors.red),
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Text(
          state ? 'Good' : 'Bad',
          style: boldTextStyle(size: 40.0),
        ),
      ),
    );
  }
}
