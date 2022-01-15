import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.white;
const TextStyle infoTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w300,
);
const TextStyle boldTextStyle =
    TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold);

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
