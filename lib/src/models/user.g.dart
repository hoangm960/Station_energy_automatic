// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'displayName': instance.displayName,
      'type': instance.type,
    };