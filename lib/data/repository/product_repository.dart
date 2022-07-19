import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/source/product_datasource.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAll({required SortType sort});

  Future<List<ProductEntity>> search({required String search});
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<ProductEntity>> getAll({required SortType sort}) {
    return dataSource.getAll(sort: sort);
  }

  @override
  Future<List<ProductEntity>> search({required String search}) {
    return dataSource.search(search: search);
  }
}
