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
}

class Type {
  final int id;
  final String name;

  Type({required this.id, required this.name});
}
