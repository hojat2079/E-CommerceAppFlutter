import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/entity/comment_entity.dart';
import 'package:ecommerce_app/data/repository/comment_repository.dart';
import 'package:equatable/equatable.dart';

part 'comment_list_event.dart';

part 'comment_list_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final CommentRepository commentRepository;
  final int productId;

  CommentListBloc({required this.commentRepository, required this.productId})
      : super(CommentListLoading()) {
    on<CommentListEvent>((event, emit) async {
      if (event is CommentListStarted || event is CommentListRefresh) {
        try {
          emit(CommentListLoading());
          final comments =
              await commentRepository.getAllComment(productId.toString());
          emit(CommentListSuccess(comments));
        } catch (ex) {
          emit(CommentListError(
              ex is CustomError ? ex : CustomError(errorCode: 500)));
        }
      }
    });
  }
}
