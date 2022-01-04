import 'package:json_annotation/json_annotation.dart';

import 'location.dart';
part 'station.g.dart';

@JsonSerializable(explicitToJson: true)
class Station {
  final int id;
  final String name;
  Location location;
  final bool state;
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
    this.voltDC = 0.0,
    this.currentDC = 0.0,
    this.voltAC = 0.0,
    this.currentAC = 0.0,
    this.energy = 0.0,
    this.frequency = 0.0,
    this.powerFactor = 0.0,
  });

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);
}
