import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:ocean_station_auto/src/models/station_list.dart';
import 'package:path_provider/path_provider.dart';

import 'models/user.dart';

const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.white;
TextStyle infoTextStyle({Color? color, double? size}) =>
    TextStyle(fontSize: size ?? 18.0, fontWeight: FontWeight.w300, color: color);
TextStyle boldTextStyle({Color? color, double? size}) =>
    TextStyle(fontSize: size ?? 30.0, fontWeight: FontWeight.bold, color: color);
Size getScreenSize(context) {
  return MediaQuery.of(context).size;
}

class Paths {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get userFile async {
    final path = await localPath;
    return File('$path/user.json');
  }

  Future<File> get stationsFile async {
    final path = await localPath;
    return File('$path/stations.json');
  }
}

Future getUser() async {
  Paths paths = Paths();
  final file = await paths.userFile;

  final contents = await file.readAsString();
  final Map<String, dynamic> jsonUser = json.decode(contents);
  return User.fromJson(jsonUser);
}

Future<Station> getStation(stationIndex) async {
  await StationList().init();
  Paths paths = Paths();
  final file = await paths.stationsFile;

  final contents = await file.readAsString();
  final List jsonStations = contents.isNotEmpty ? json.decode(contents) : [];
  return List.generate(jsonStations.length,
      (index) => Station.fromJson(jsonStations[index]))[stationIndex];
}
