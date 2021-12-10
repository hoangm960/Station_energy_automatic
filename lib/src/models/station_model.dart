class Station {
  final String name;
  Location location;
  final bool state;
  final double? voltDC;
  final double? currentDC;
  final double? voltAC;
  final double? currentAC;
  final double? power;
  final double? energy;
  final double? frequency;
  final double? powerFactor;

  Station({
    required this.name,
    required this.location,
    required this.power,
    required this.state,
    this.voltDC,
    this.currentDC,
    this.voltAC,
    this.currentAC,
    this.energy,
    this.frequency,
    this.powerFactor,
  });
}

class Location {
  final double x;
  final double y;

  Location({required this.x, required this.y});
}

List<Station> stationList = [
  Station(
      name: 'Station 1',
      location: Location(x: 16.596762, y: 108.121324),
      power: 100,
      state: false),
  Station(
      name: 'Station 2',
      location: Location(x: 50, y: 20),
      power: 220,
      state: true),
  Station(
      name: 'Station 3',
      location: Location(x: 300, y: 300),
      power: 220,
      state: true),
];
