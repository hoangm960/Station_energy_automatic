import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  final String displayName;
  final String type;
  final int typeId;
  final int? stationId;

  User(
      {required this.id,
      required this.username,
      required this.displayName,
      required this.type,
      required this.typeId,
      this.stationId});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class Type {
  final int id;
  final String name;

  Type({required this.id, required this.name});
}
