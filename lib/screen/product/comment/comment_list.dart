import 'package:ecommerce_app/component/widget/error.dart';
import 'package:ecommerce_app/component/widget/loading.dart';
import 'package:ecommerce_app/data/entity/comment_entity.dart';
import 'package:ecommerce_app/data/repository/comment_repository.dart';
import 'package:ecommerce_app/screen/product/comment/bloc/comment_list_bloc.dart';
import 'package:ecommerce_app/screen/product/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentList extends StatelessWidget {
  final int productId;

  const CommentList({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CommentListBloc bloc = CommentListBloc(
            commentRepository: context.read<CommentRepository>(),
            productId: productId);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
          builder: (context, state) {
        if (state is CommentListError) {
          return SliverToBoxAdapter(
            child: CustomErrorWidget(
                error: state.customError,
                onTap: () {
                  BlocProvider.of<CommentListBloc>(context)
                      .add(CommentListRefresh());
                }),
          );
        } else if (state is CommentListLoading) {
          return SliverToBoxAdapter(
            child: LoadingWidget(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        } else if (state is CommentListSuccess) {
          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return CommentItem(
                    comment: state.comments[index],
                  );
                },
                childCount: state.comments.length,
              ),
            ),
          );
        } else {
          throw Exception('state is not supported.');
        }
      }),
    );
  }
}
