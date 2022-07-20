import 'package:ecommerce_app/data/entity/product_entity.dart';

class OrderHistoryEntity {
  final int id;
  final int payablePrice;
  final String paymentStatus;
  final List<ProductEntity> products;

  OrderHistoryEntity(
    this.id,
    this.payablePrice,
    this.paymentStatus,
    this.products,
  );

  OrderHistoryEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        paymentStatus = json['payment_status'],
        products = (json['order_items'] as List)
            .map((e) => ProductEntity.fromJson(e['product']))
            .toList();
}
