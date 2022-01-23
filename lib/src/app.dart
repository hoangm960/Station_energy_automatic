import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:ocean_station_auto/src/screens/home/home_page.dart';
import 'package:ocean_station_auto/src/screens/login_page/login_page.dart';
import 'package:ocean_station_auto/src/screens/profile_page.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/camera.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/employee_list.dart';
import 'package:ocean_station_auto/src/screens/station_page/components/find_repairer.dart';
import 'package:ocean_station_auto/src/screens/station_page/station_page.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('vi', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
              primaryColor: primaryColor, secondaryHeaderColor: secondaryColor),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case ProfileScreen.routeName:
                    return const ProfileScreen();
                  case StationScreen.routeName:
                    Map stationArgs = routeSettings.arguments as Map;
                    return StationScreen(stationArgs['station']);
                  case LiveStreamingPlayer.routeName:
                    Map playerArgs = routeSettings.arguments as Map;
                    return LiveStreamingPlayer(index: playerArgs['index'],);
                  case RepairerPage.routeName:
                    Map stationArgs = routeSettings.arguments as Map;
                    return RepairerPage(stationId: stationArgs['id'],);
                  case EmployeeListPage.routeName:
                    Map stationArgs = routeSettings.arguments as Map;
                    return EmployeeListPage(stationId: stationArgs['id'],);
                  case LoginPage.routeName:
                    return const LoginPage();
                  case HomePage.routeName:
                    return const HomePage();
                  default:
                    return const LoginPage();
                }
              },
            );
          },
        );
      },
    );
  }
}
