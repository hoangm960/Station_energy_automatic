// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    username: json['username'] as String,
    displayName: json['displayName'] as String,
    type: json['type'] as String,
    typeId: json['typeId'] as int,
    stationId: json['stationId'] as int?);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'type': instance.type,
      'typeId': instance.typeId,
      'stationId': instance.stationId
    };
