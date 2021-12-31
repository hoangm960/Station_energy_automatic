import 'package:json_annotation/json_annotation.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String username;
  final String displayName;
  final String type;


  User({required this.username, required this.displayName, required this.type});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class Type {
  final int id;
  final String name;

  Type({required this.id, required this.name});
}
