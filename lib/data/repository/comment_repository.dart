import 'package:ecommerce_app/data/entity/banner_entity.dart';
import 'package:ecommerce_app/data/entity/comment_entity.dart';
import 'package:ecommerce_app/data/source/comment_datasource.dart';

abstract class CommentRepository {
  Future<List<CommentEntity>> getAllComment(String productId);
}

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource commentRemoteDataSource;

  CommentRepositoryImpl(this.commentRemoteDataSource);

  @override
  Future<List<CommentEntity>> getAllComment(String productId) {
    return commentRemoteDataSource.getAllComments(productId);
  }
}
