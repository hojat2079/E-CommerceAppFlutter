class AddToCartResponse {
  final int productId;
  final int cartItemId;
  final int count;

  AddToCartResponse({
    required this.productId,
    required this.cartItemId,
    required this.count,
  });

  AddToCartResponse.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        cartItemId = json['id'],
        count = json['count'];
}
