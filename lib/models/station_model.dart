class Station {
  final String name;
  Location location;
  final double power;
  final bool state;

  Station(
      {required this.name,
      required this.location,
      required this.power,
      required this.state});
}

class Location {
  final double x;
  final double y;

  Location({required this.x, required this.y});
}
