import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StationGraphList extends StatelessWidget {
  const StationGraphList({
    Key? key,
    required this.type,
    required this.id,
  }) : super(key: key);
  final bool type;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type ? 'Output DC' : 'Output AC',
            style: boldTextStyle,
          ),
          Row(
            children: [
              Expanded(
                child: StationGraph(
                  type: type ? 'voltDC' : 'voltAC',
                  id: id,
                ),
              ),
              Expanded(
                child: StationGraph(type: type ? 'currentDC' : 'currentAC', id: id),
              ),
            ],
          ),
          StationGraph(type: type ? 'voltDC * currentDC' : 'energyAC', id: id),
        ],
      ),
    );
  }
}

class StationGraph extends StatefulWidget {
  final String type;
  final int id;
  const StationGraph({Key? key, required this.type, required this.id})
      : super(key: key);

  @override
  State<StationGraph> createState() => _StationGraphState();
}

class _StationGraphState extends State<StationGraph> {
  int time = 1;
  List<ChartData> chartData = [];
  int count = 7;
  late Timer timer;
  final random = Random();
  ChartSeriesController? _chartSeriesController;
  double value = 0.0;
  var db = Mysql();
  late Future<MySqlConnection> connection;

  void _getParam() {
    connection.then((connection) {
      String sql =
          'SELECT ${widget.type} FROM station WHERE stationId = ${widget.id}';
      connection.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            value = row[0];
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), _updateDataSource);
    connection = db.getConnection();
    _getParam();
  }

  @override
  void dispose() async {
    timer.cancel();
    super.dispose();
  }

  void _updateDataSource(Timer timer) {
    _getParam();
    chartData.add(ChartData(time, value));
    if (chartData.length == 20) {
      chartData.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
      );
    }
    setState(() {
      time += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      height: 626.0,
      color: Colors.black45,
      child: SfCartesianChart(
          backgroundColor: secondaryColor,
          borderColor: primaryColor,
          borderWidth: 2.0,
          enableAxisAnimation: true,
          series: <LineSeries<ChartData, int>>[
            LineSeries<ChartData, int>(
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y),
          ]),
    );
  }
}

class ChartData {
  int x;
  double y;
  ChartData(this.x, this.y);
}
