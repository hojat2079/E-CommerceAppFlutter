import 'package:ecommerce_app/data/entity/comment_entity.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;

  const CommentItem({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
        border: Border.all(color: themeData.dividerColor, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.title,
                maxLines: 1,
                style: themeData.textTheme.bodyText1,
              ),
              Text(
                comment.date,
                maxLines: 1,
                style: themeData.textTheme.caption,
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            comment.email,
            maxLines: 1,
            style: themeData.textTheme.caption,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            comment.content,
            style: themeData.textTheme.bodyText2!.copyWith(height: 1.4),
          )
        ],
      ),
    );
  }
}
