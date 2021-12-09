import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/models/station_model.dart';

class StationScreen extends StatefulWidget {
  final int index;
  const StationScreen(this.index, {Key? key}) : super(key: key);

  static const routeName = '/station';

  @override
  _StationScreenState createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  Station? station;

  @override
  void initState() {
    super.initState();
    station = stationList[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(station!.name),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Location: ${station!.location.x} ${station!.location.y}'),
        Text('VoltDC: ${station!.voltDC} V'),
        Text('CurrentDC: ${station!.currentDC} A'),
        Text('VoltAC: ${station!.voltAC} V'),
        Text('CurrentAC: ${station!.currentAC} A'),
        Text('Power: ${station!.power} W'),
        Text('Energy: ${station!.energy} kW/h'),
        Text('Power Factor: ${station!.powerFactor}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('State: '),
            station!.state
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
