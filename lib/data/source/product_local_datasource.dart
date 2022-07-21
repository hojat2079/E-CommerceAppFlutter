import 'package:ecommerce_app/common/constant.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/source/local_datasource.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductLocalDataSource implements LocalDataSource<ProductEntity> {
  final Box<ProductEntity> _box;

  ProductLocalDataSource(this._box);

  static Future<void> init() async {
    Hive.registerAdapter(ProductEntityAdapter());
    await Hive.openBox<ProductEntity>(Constant.favoriteBox);
  }

  @override
  Future<void> createOrUpdate(ProductEntity data) {
    return _box.put(data.id, data);
  }

  @override
  Future<void> delete(ProductEntity data) {
    return _box.delete(data.id);
  }

  @override
  Future<void> deleteAll() {
    return _box.clear();
  }

  @override
  Future<List<ProductEntity>> getAll({String searchKeyboard = ""}) async {
    return _box.values
        .where((element) => element.title.contains(searchKeyboard))
        .toList();
  }

  @override
  Future<ProductEntity> getElementById({id}) async {
    return _box.values.firstWhere((element) => element.id == id);
  }

  @override
  bool isExist(ProductEntity data) {
    return _box.containsKey(data.id);
  }
}
