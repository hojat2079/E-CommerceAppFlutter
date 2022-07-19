import 'package:ecommerce_app/data/entity/product_entity.dart';

class CartItemEntity {
  final ProductEntity productEntity;
  final int id;
  int count;
  bool showLoadingDelete = false;
  bool showLoadingChangeCount = false;

  CartItemEntity({
    required this.productEntity,
    required this.id,
    required this.count,
  });

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : id = json['cart_item_id'],
        count = json['count'],
        productEntity = ProductEntity.fromJson(json['product']);

  static List<CartItemEntity> fromJsonArray(List<dynamic> jsonArray) {
    final List<CartItemEntity> result = [];

    for (var element in jsonArray) {
      result.add(CartItemEntity.fromJson(element));
    }
    return result;
  }
}
