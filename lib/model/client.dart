import 'package:hive/hive.dart';

part 'client.g.dart';

@HiveType(typeId: 3)
class ClientDb {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String phonenumber;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String place;
  @HiveField(4)
  final String secondarynumber;
  @HiveField(5)
  String? id;
  @HiveField(6)
  double? latittude;
  @HiveField(7)
  double? longittude;
  ClientDb({
    required this.name,
    required this.phonenumber,
    required this.place,
    required this.email,
    required this.secondarynumber,
    this.latittude,
    this.longittude,
  }) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
