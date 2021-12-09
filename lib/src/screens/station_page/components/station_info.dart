import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';

class StationInfo extends StatelessWidget {
  final Station station;
  const StationInfo({Key? key, required this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Location: ${station.location.x} ${station.location.y}',
          style: infoTextStyle,
        ),
        Text(
          'VoltDC: ${station.voltDC} V',
          style: infoTextStyle,
        ),
        Text(
          'CurrentDC: ${station.currentDC} A',
          style: infoTextStyle,
        ),
        Text(
          'VoltAC: ${station.voltAC} V',
          style: infoTextStyle,
        ),
        Text(
          'CurrentAC: ${station.currentAC} A',
          style: infoTextStyle,
        ),
        Text(
          'Power: ${station.power} W',
          style: infoTextStyle,
        ),
        Text(
          'Energy: ${station.energy} kW/h',
          style: infoTextStyle,
        ),
        Text(
          'Power Factor: ${station.powerFactor}',
          style: infoTextStyle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'State: ',
              style: infoTextStyle,
            ),
            station.state
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
      ]),
    );
  }
}