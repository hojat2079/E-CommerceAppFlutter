class ProductEntity {
  final int id;
  final String title;
  final int price;
  final int discount;
  final String imagePath;
  final int previousPrice;

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        price = json['price'],
        discount = json['discount'],
        imagePath = json['image'],
        previousPrice =
            json['previous_price'] ?? json['price'] + json['discount'];
}
