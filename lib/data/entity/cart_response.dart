import 'package:ecommerce_app/data/entity/cart_item_entity.dart';

class CartResponse {
  final List<CartItemEntity> cartItems;
  int payablePrice;
  int totalPrice;
  int shippingCost;

  CartResponse({
    required this.cartItems,
    required this.payablePrice,
    required this.totalPrice,
    required this.shippingCost,
  });

  CartResponse.fromJson(Map<String, dynamic> json)
      : cartItems = CartItemEntity.fromJsonArray(json['cart_items']),
        payablePrice = json['payable_price'],
        totalPrice = json['total_price'],
        shippingCost = json['shipping_cost'];
}
