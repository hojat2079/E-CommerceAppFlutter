import 'package:ecommerce_app/data/api_service/api_service.dart';
import 'package:ecommerce_app/data/entity/comment_entity.dart';

abstract class CommentDataSource {
  Future<List<CommentEntity>> getAllComments(String productId);
}

class CommentRemoteDataSource implements CommentDataSource {
  final ApiService apiService;

  CommentRemoteDataSource(this.apiService);

  @override
  Future<List<CommentEntity>> getAllComments(String productId) {
    return apiService.getComment(productId);
  }
}
