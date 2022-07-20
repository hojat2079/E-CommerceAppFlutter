import 'package:ecommerce_app/data/api_service/api_service.dart';
import 'package:ecommerce_app/data/entity/checkout_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_params_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_result_entity.dart';
import 'package:ecommerce_app/data/entity/history_order_entity.dart';

abstract class OrderDataSource {
  Future<CreateOrderResultEntity> submitOrder(CreateOrderParamsEntity params);
  Future<CheckoutEntity> checkout(int orderId);
  Future<List<OrderHistoryEntity>> getHistoryOrder();
}

class OrderRemoteDataSource implements OrderDataSource {
  final ApiService apiService;

  OrderRemoteDataSource(this.apiService);

  @override
  Future<CreateOrderResultEntity> submitOrder(CreateOrderParamsEntity params) {
    return apiService.submitOrder(params);
  }

  @override
  Future<CheckoutEntity> checkout(int orderId) {
    return apiService.checkout(orderId);
  }

  @override
  Future<List<OrderHistoryEntity>> getHistoryOrder() {
    return apiService.getHistoryOrder();
  }
}
