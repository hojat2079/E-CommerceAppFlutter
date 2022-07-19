import 'package:dio/dio.dart';
import 'package:ecommerce_app/data/api_service/api_service.dart';
import 'package:ecommerce_app/data/common/http_response_validator.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';

abstract class ProductDataSource {
  Future<List<ProductEntity>> getAll({required SortType sort});

  Future<List<ProductEntity>> search({required String search});
}

class ProductRemoteDataSource implements ProductDataSource {
  final ApiService apiService;

  ProductRemoteDataSource(this.apiService);

  @override
  Future<List<ProductEntity>> getAll({required SortType sort}) {
    return apiService.getAllProduct(sort);
  }

  @override
  Future<List<ProductEntity>> search({required String search}) async {
    return apiService.searchProduct(search);
  }
}
