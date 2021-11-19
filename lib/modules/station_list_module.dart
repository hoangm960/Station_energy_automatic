import 'package:flutter/material.dart';
import 'package:ocean_station_auto/models/station_model.dart';

class StationList extends StatefulWidget {
  final List<Station> stations;

  const StationList(this.stations, {Key? key}) : super(key: key);

  @override
  _StationListState createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  Widget _buildStationCard(int index) {
    return Card(
      elevation: 5.0,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.stations[index].name,
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
                      Text(widget.stations[index].location.x.toString()),
                      const VerticalDivider(
                        width: 5.0,
                      ),
                      Text(widget.stations[index].location.y.toString()),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Power: '),
                  Text(widget.stations[index].power.toString() + '(W)')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('State: '),
                  const SizedBox(
                    width: 38.0,
                  ),
                  widget.stations[index].state
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

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 300,
      padding: const EdgeInsets.all(10.0),
      children: List.generate(
          widget.stations.length, (index) => _buildStationCard(index)),
    );
  }
}
