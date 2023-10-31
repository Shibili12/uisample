import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class ProductDb {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int price;

  ProductDb({
    required this.id,
    required this.title,
    required this.price,
  });
}
