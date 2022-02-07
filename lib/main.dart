import 'package:flutter/material.dart';
import 'package:ocean_station_auto/src/state_container.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(StateContainer(child: MyApp(settingsController: settingsController)));
}