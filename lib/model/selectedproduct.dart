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
  Selectedproducts({
    required this.title,
    required this.price,
  }) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
