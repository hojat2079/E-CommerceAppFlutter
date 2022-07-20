import 'package:ecommerce_app/data/entity/checkout_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_params_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_result_entity.dart';
import 'package:ecommerce_app/data/entity/history_order_entity.dart';
import 'package:ecommerce_app/data/source/order_datasource.dart';

abstract class OrderRepository {
  Future<CreateOrderResultEntity> submitOrder(CreateOrderParamsEntity params);

  Future<CheckoutEntity> checkout(int orderId);

  Future<List<OrderHistoryEntity>> getHistoryOrder();
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource orderDataSource;

  OrderRepositoryImpl(this.orderDataSource);

  @override
  Future<CreateOrderResultEntity> submitOrder(CreateOrderParamsEntity params) {
    return orderDataSource.submitOrder(params);
  }

  @override
  Future<CheckoutEntity> checkout(int orderId) {
    return orderDataSource.checkout(orderId);
  }

  @override
  Future<List<OrderHistoryEntity>> getHistoryOrder() {
    return orderDataSource.getHistoryOrder();
  }
}
