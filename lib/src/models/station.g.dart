// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Station _$StationFromJson(Map<String, dynamic> json) => Station(
      name: json['name'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      power: (json['power'] as num?)?.toDouble(),
      state: json['state'] as bool,
      voltDC: (json['voltDC'] as num?)?.toDouble(),
      currentDC: (json['currentDC'] as num?)?.toDouble(),
      voltAC: (json['voltAC'] as num?)?.toDouble(),
      currentAC: (json['currentAC'] as num?)?.toDouble(),
      energy: (json['energy'] as num?)?.toDouble(),
      frequency: (json['frequency'] as num?)?.toDouble(),
      powerFactor: (json['powerFactor'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'name': instance.name,
      'location': instance.location.toJson(),
      'state': instance.state,
      'voltDC': instance.voltDC,
      'currentDC': instance.currentDC,
      'voltAC': instance.voltAC,
      'currentAC': instance.currentAC,
      'power': instance.power,
      'energy': instance.energy,
      'frequency': instance.frequency,
      'powerFactor': instance.powerFactor,
    };
