import 'package:hive/hive.dart';

part 'selectedproduct.g.dart';

@HiveType(typeId: 2)
class Selectedproducts {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int price;
  @HiveField(3)
  final String total;
  @HiveField(4)
  final String tax;
  @HiveField(5)
  final String taxamound;
  @HiveField(6)
  final String salesvalue;
  @HiveField(7)
  final String qty;
  @HiveField(8)
  final String enquiryId;
  Selectedproducts({
    required this.title,
    required this.price,
    required this.total,
    required this.tax,
    required this.taxamound,
    required this.salesvalue,
    required this.qty,
    required this.enquiryId,
  }) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
