import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:weather/weather.dart';
import 'package:ocean_station_auto/src/utils/return_system.dart';

class WeatherInfo {
  String key = '856822fd8e22db5e1ba48c0e7d69844a';
  late WeatherFactory ws;
  final double lat;
  final double lon;

  WeatherInfo(this.lat, this.lon) {
    ws = WeatherFactory(key);
  }

  Future getWindSpeed() async {
    Weather weather = await ws.currentWeatherByLocation(lat, lon);
    return weather.windSpeed;
  }
}

void checkWindSpeed(MySqlConnection connection, BuildContext context, Station station) async {
  double maxWindspeed = 10.0;

  double windSpeed =
      await WeatherInfo(station.location.x, station.location.y).getWindSpeed();
  bool _alerted = await checkReturn(connection, station.id);
  if (windSpeed > maxWindspeed && !_alerted) {
    _windAlert(connection, context, station);
  }
}

void _windAlert(MySqlConnection connection, BuildContext context, Station station) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(
              '${station.name} encountered overpowered wind (> 10 km/h). Please allow access to the returning system',
              style: infoTextStyle(),
            ),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    returnSystem(connection, station.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('OK')),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'))
            ],
          ));
}
