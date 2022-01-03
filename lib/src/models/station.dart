
import 'package:json_annotation/json_annotation.dart';

import 'location.dart';
part 'station.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);
}
