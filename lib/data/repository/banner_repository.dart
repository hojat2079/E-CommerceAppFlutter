import 'package:ecommerce_app/data/entity/banner_entity.dart';
import 'package:ecommerce_app/data/source/banner_datasource.dart';

abstract class BannerRepository {
  Future<List<BannerEntity>> getAllBanner();
}

class BannerRepositoryImpl implements BannerRepository {
  final BannerDataSource remoteDataSource;

  BannerRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<BannerEntity>> getAllBanner() {
    return remoteDataSource.getAllBanner();
  }
}
