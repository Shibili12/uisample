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
  ClientDb({
    required this.name,
    required this.phonenumber,
    required this.place,
    required this.email,
    required this.secondarynumber,
  });
}
