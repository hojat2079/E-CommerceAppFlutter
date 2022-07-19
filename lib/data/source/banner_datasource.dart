import 'package:ecommerce_app/data/api_service/api_service.dart';
import 'package:ecommerce_app/data/entity/banner_entity.dart';

abstract class BannerDataSource {
  Future<List<BannerEntity>> getAllBanner();
}

class BannerRemoteDataSource implements BannerDataSource {
  final ApiService apiService;

  BannerRemoteDataSource(this.apiService);

  @override
  Future<List<BannerEntity>> getAllBanner() {
    return apiService.getBanner();
  }
}
