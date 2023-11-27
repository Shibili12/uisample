import 'package:hive/hive.dart';

part 'orderproducts.g.dart';

@HiveType(typeId: 7)
class Orderproducts {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String title;
  @HiveField(2)
  int price;
  @HiveField(3)
  String total;
  @HiveField(4)
  String tax;
  @HiveField(5)
  String taxamound;
  @HiveField(6)
  String salesvalue;
  @HiveField(7)
  String qty;
  @HiveField(8)
  String orderid;
  Orderproducts({
    required this.title,
    required this.price,
    required this.total,
    required this.tax,
    required this.taxamound,
    required this.salesvalue,
    required this.qty,
    required this.orderid,
  }) {
    id = DateTime.now().minute.toString();
  }
}
