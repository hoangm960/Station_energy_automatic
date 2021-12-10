import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StationGraphList extends StatelessWidget {
  final String title;
  const StationGraphList({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: boldTextStyle,
          ),
          Row(
            children: const [
              Expanded(
                child: StationGraph(),
              ),
              Expanded(
                child: StationGraph(),
              ),
            ],
          ),
          const StationGraph(),
        ],
      ),
    );
  }
}

class StationGraph extends StatefulWidget {
  const StationGraph({Key? key}) : super(key: key);

  @override
  State<StationGraph> createState() => _StationGraphState();
}

class _StationGraphState extends State<StationGraph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      height: 626.0,
      color: Colors.black45,
      child: SfCartesianChart(),
    );
  }
}
