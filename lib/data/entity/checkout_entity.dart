class CheckoutEntity {
  final bool purchaseSuccess;
  final int payablePrice;
  final String paymentStatus;

  CheckoutEntity(this.purchaseSuccess, this.payablePrice, this.paymentStatus);

  CheckoutEntity.fromJson(Map<String, dynamic> json)
      : purchaseSuccess = json['purchase_success'],
        payablePrice = json['payable_price'],
        paymentStatus = json['payment_status'];
}
