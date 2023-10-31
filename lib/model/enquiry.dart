import 'package:hive/hive.dart';

part 'enquiry.g.dart';

@HiveType(typeId: 1)
class Enquiry {
  @HiveField(0)
  final String primarynumber;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String secondarynumber;
  @HiveField(3)
  final String whatsappnumber;
  @HiveField(4)
  final String outsidemob;
  @HiveField(5)
  final String followdate;
  @HiveField(6)
  final String followtime;
  @HiveField(7)
  final String expclosure;
  @HiveField(8)
  final String source;
  @HiveField(9)
  final String assigneduser;
  @HiveField(10)
  final String taguser;
  @HiveField(11)
  final String location;
  @HiveField(12)
  final String referedby;
  @HiveField(13)
  final String email;
  @HiveField(14)
  String? id;

  Enquiry({
    required this.primarynumber,
    required this.name,
    required this.secondarynumber,
    required this.whatsappnumber,
    required this.outsidemob,
    required this.followdate,
    required this.followtime,
    required this.expclosure,
    required this.source,
    required this.assigneduser,
    required this.taguser,
    required this.location,
    required this.referedby,
    required this.email,
  }) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
