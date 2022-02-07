import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/state_container.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/station.dart';

enum ConnectionState { notDownloaded, loading, finished }

class StationGraphList extends StatefulWidget {
  final bool type;
  final int index;

  const StationGraphList({Key? key, required this.type, required this.index})
      : super(key: key);

  @override
  State<StationGraphList> createState() => _StationGraphListState();
}

class _StationGraphListState extends State<StationGraphList> {
  late Station station;
  late List info;

  @override
  Widget build(BuildContext context) {
    station = StateContainer.of(context).stationList[widget.index];
    info = (widget.type)
        ? [
            'Output DC',
            'Volt: ${station.voltDC.toStringAsFixed(2)} V',
            'Current: ${station.currentDC.toStringAsFixed(2)} A'
          ]
        : [
            'OutputAC',
            'Volt: ${station.voltAC.toStringAsFixed(2)} V',
            'Current: ${station.currentAC.toStringAsFixed(2)} A',
            'Power: ${station.power.toStringAsFixed(2)} W',
            'Energy: ${station.power.toStringAsFixed(2)} kWh',
            'Frequency: ${station.power.toStringAsFixed(2)} Hz',
            'Power Factor: ${station.power.toStringAsFixed(2)}',
          ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Column(children: [
            Expanded(
              flex: 2,
              child: StationGraph(
                type: widget.type ? 'voltDC * currentDC' : 'energyAC',
                unit: 'kWh',
                station: station,
                title: 'Power',
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: StationGraph(
                    type: widget.type ? 'voltDC' : 'voltAC',
                    unit: 'V',
                    station: station,
                    title: 'Voltage',
                  )),
                  Expanded(
                    child: StationGraph(
                      type: widget.type ? 'currentDC' : 'currentAC',
                      unit: 'A',
                      station: station,
                      title: 'Current',
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        const VerticalDivider(
          thickness: 2.0,
          color: Colors.white,
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(info.length, (index) {
              return (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 25.0, right: 3.0),
                      child: Text(
                        info[index],
                        style: infoTextStyle(),
                      ),
                    )
                  : Container(
                      decoration: roundedBorder(),
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.fromLTRB(2.0, 10.0, 3.0, 35.0),
                      child: Text(
                        info[index],
                        style: boldTextStyle(size: 23.0),
                      ));
            }),
          ),
        )
      ],
    );
  }
}

class StationGraph extends StatefulWidget {
  final String type;
  final String unit;
  final Station station;
  final String title;
  const StationGraph(
      {Key? key,
      required this.type,
      required this.unit,
      required this.station,
      required this.title})
      : super(key: key);

  @override
  State<StationGraph> createState() => _StationGraphState();
}

class _StationGraphState extends State<StationGraph> {
  int time = 1;
  List<ChartData> chartData = [];
  late Timer timer;
  ChartSeriesController? _chartSeriesController;
  double value = 0.0;
  var db = Mysql();
  late MySqlConnection connection;
  ConnectionState _connState = ConnectionState.notDownloaded;

  void _getParam() async {
    String sql =
        'SELECT ${widget.type} FROM station WHERE stationId = ${widget.station.id}';
    connection.query(sql).then((results) {
      for (var row in results) {
        setState(() {
          value = num.parse(row[0].toStringAsFixed(2)).toDouble();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), _updateDataSource);
    setUpConn();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
    _getParam();
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
    return (_connState == ConnectionState.finished)
        ? Container(
            margin: const EdgeInsets.all(10.0),
            child: SfCartesianChart(
                title: ChartTitle(text: widget.title, textStyle: boldTextStyle(color: Colors.black, size: 20.0)),
                backgroundColor: secondaryColor,
                borderColor: primaryColor,
                borderWidth: 2.0,
                enableAxisAnimation: true,
                primaryXAxis: NumericAxis(isVisible: false),
                primaryYAxis: NumericAxis(
                    labelFormat: '{value}${widget.unit}',
                    anchorRangeToVisiblePoints: false,
                    labelStyle: const TextStyle(color: Colors.black)),
                series: <LineSeries<ChartData, int>>[
                  LineSeries<ChartData, int>(
                      onRendererCreated: (ChartSeriesController controller) {
                        _chartSeriesController = controller;
                      },
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.red),
                ]),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class ChartData {
  int x;
  double y;
  ChartData(this.x, this.y);
}
