class CreateOrderResultEntity {
  final int orderId;
  final String bankGatewayUrl;

  CreateOrderResultEntity(this.orderId, this.bankGatewayUrl);

  CreateOrderResultEntity.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}
