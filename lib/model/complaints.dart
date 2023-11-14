import 'package:hive/hive.dart';

part 'complaints.g.dart';

@HiveType(typeId: 4)
class Complaint {
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
  @HiveField(15)
  final String remarks;
  @HiveField(16)
  String? audiopath;
  Complaint({
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
    required this.remarks,
    this.audiopath,
  }) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
