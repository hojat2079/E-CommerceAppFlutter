class CreateOrderParamsEntity {
  final String firstName;
  final String lastName;
  final String postalCode;
  final String phoneNumber;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParamsEntity({
    required this.firstName,
    required this.lastName,
    required this.postalCode,
    required this.phoneNumber,
    required this.address,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'mobile': phoneNumber,
      'postal_code': postalCode,
      'address': address,
      'payment_method':
          paymentMethod == PaymentMethod.online ? 'online' : 'cash_on_delivery'
    };
  }
}

enum PaymentMethod {
  online,
  cashOnDelivery,
}
