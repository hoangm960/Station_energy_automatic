import 'package:weather/weather.dart';

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
