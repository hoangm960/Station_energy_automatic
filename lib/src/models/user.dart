import 'package:json_annotation/json_annotation.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ocean_station_auto/src/utils/connectDb.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  final String displayName;
  final String type;
  var db = Mysql();
  late MySqlConnection connection;

  User({required this.id, required this.username, required this.displayName, required this.type});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Future<int> getTypeId() async {
    int id = 0;

    connection = await db.getConn();
    String sql = 'SELECT typeId FROM type WHERE name = $type';
    var results = await connection.query(sql);
    for (var row in results) {
      id = row[0];
    }
    return id;
  }
}

class Type {
  final int id;
  final String name;

  Type({required this.id, required this.name});
}
