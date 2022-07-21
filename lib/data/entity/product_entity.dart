import 'package:hive_flutter/adapters.dart';

part 'product_entity.g.dart';

@HiveType(typeId: 0)
class ProductEntity extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int price;
  @HiveField(3)
  final int discount;
  @HiveField(4)
  final String imagePath;
  @HiveField(5)
  final int previousPrice;

  ProductEntity(
    this.id,
    this.title,
    this.price,
    this.discount,
    this.imagePath,
    this.previousPrice,
  );

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        price = json['price'],
        discount = json['discount'],
        imagePath = json['image'],
        previousPrice =
            json['previous_price'] ?? json['price'] + json['discount'];
}
