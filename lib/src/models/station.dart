import 'location.dart';

class Station {
  final int id;
  final String name;
  Location location;
  bool state;
  bool returned;
  final double voltDC;
  final double currentDC;
  final double voltAC;
  final double currentAC;
  final double power;
  final double energy;
  final double frequency;
  final double powerFactor;

  Station({
    required this.id,
    required this.name,
    required this.location,
    required this.power,
    this.state = true,
    this.returned = false,
    this.voltDC = 0.0,
    this.currentDC = 0.0,
    this.voltAC = 0.0,
    this.currentAC = 0.0,
    this.energy = 0.0,
    this.frequency = 0.0,
    this.powerFactor = 0.0,
  });
}
