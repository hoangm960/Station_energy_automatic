import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/state_container.dart';

import 'src/app.dart';

void main() async {
  runApp(const StateContainer(child: MyApp()));
}