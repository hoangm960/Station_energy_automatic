import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/models/station.dart';
import 'package:path_provider/path_provider.dart';

import 'models/user.dart';

const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.white;
TextStyle infoTextStyle({Color? color, double? size}) => TextStyle(
    fontSize: size ?? 18.0, fontWeight: FontWeight.w300, color: color);
TextStyle boldTextStyle({Color? color, double? size}) => TextStyle(
    fontSize: size ?? 30.0, fontWeight: FontWeight.bold, color: color);
Size getScreenSize(context) {
  return MediaQuery.of(context).size;
}

BoxDecoration roundedBorder({Color? color, Color? borderColor,}) => BoxDecoration(
    color: color,
    border: Border.all(color: borderColor ?? Colors.white),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)));

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