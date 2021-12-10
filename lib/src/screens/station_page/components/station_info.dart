import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';

class StationInfo extends StatefulWidget {
  final Station station;
  const StationInfo({Key? key, required this.station}) : super(key: key);

  @override
  State<StationInfo> createState() => _StationInfoState();
}

class _StationInfoState extends State<StationInfo> {
  String dropdownValue = 'One';
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenSize(context).height - 18.0*2,
      padding: const EdgeInsets.all(18.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Location: ${widget.station.location.x} ${widget.station.location.y}',
              style: infoTextStyle,
            ),
            Text(
              'VoltDC: ${widget.station.voltDC} V',
              style: infoTextStyle,
            ),
            Text(
              'CurrentDC: ${widget.station.currentDC} A',
              style: infoTextStyle,
            ),
            Text(
              'VoltAC: ${widget.station.voltAC} V',
              style: infoTextStyle,
            ),
            Text(
              'CurrentAC: ${widget.station.currentAC} A',
              style: infoTextStyle,
            ),
            Text(
              'Power: ${widget.station.power} W',
              style: infoTextStyle,
            ),
            Text(
              'Energy: ${widget.station.energy} kW/h',
              style: infoTextStyle,
            ),
            Text(
              'Power Factor: ${widget.station.powerFactor}',
              style: infoTextStyle,
            ),
            Center(
              child: Row(
                children: [
                  const Text(
                    'State: ',
                    style: infoTextStyle,
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
                        ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: const [
                  Text(
                    'Employee List',
                    style: infoTextStyle,
                  ),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            )
          ]),
    );
  }
}
