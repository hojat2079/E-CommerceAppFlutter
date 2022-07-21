import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/source/product_local_datasource.dart';
import 'package:ecommerce_app/data/source/product_remote_datasource.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAllApi({required SortType sort});

  Future<List<ProductEntity>> search({required String search});

  Future<List<ProductEntity>> getAllDatabase({String searchKeyboard});

  Future<void> delete(ProductEntity data);

  Future<void> createOrUpdate(ProductEntity data);

  bool isExist(ProductEntity data);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<ProductEntity>> getAllApi({required SortType sort}) {
    return remoteDataSource.getAll(sort: sort);
  }

  @override
  Future<List<ProductEntity>> search({required String search}) {
    return remoteDataSource.search(search: search);
  }

  @override
  Future<void> createOrUpdate(ProductEntity data) {
    return localDataSource.createOrUpdate(data);
  }

  @override
  Future<void> delete(ProductEntity data) {
    return localDataSource.delete(data);
  }

  @override
  Future<List<ProductEntity>> getAllDatabase({String searchKeyboard = ""}) {
    return localDataSource.getAll();
  }

  @override
  bool isExist(ProductEntity data) {
    return localDataSource.isExist(data);
  }
}
