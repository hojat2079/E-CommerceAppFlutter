import 'dart:async';

import 'package:ecommerce_app/common/constant.dart';
import 'package:ecommerce_app/common/extension.dart';
import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/component/widget/image_loading_service.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:ecommerce_app/screen/product/bloc/product_bloc.dart';
import 'package:ecommerce_app/screen/product/comment/comment_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatefulWidget {
  final ProductEntity productEntity;
  final bool isFavorite;

  const DetailsScreen(
      {Key? key, required this.productEntity, required this.isFavorite})
      : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  StreamSubscription<ProductState>? streamSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();

  @override
  void dispose() {
    streamSubscription?.cancel();
    _scaffoldMessengerKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(
            context.read<CartRepository>(),
            context.read<ProductRepository>(),
            widget.isFavorite,
          );
          streamSubscription = bloc.stream.listen((state) {
            if (state is ProductAddItemToCartButtonSuccess) {
              showSnackBar(_scaffoldMessengerKey.currentState!,
                  message: 'با موفقیت به سبد خرید اضافه شد.');
            } else if (state is ProductAddItemToCartButtonError) {
              showSnackBar(_scaffoldMessengerKey.currentState!,
                  message: state.customError.message);
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldMessengerKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width - 72,
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context).add(
                          AddCartButtonClicked(widget.productEntity.id),
                        );
                      },
                      label: Center(
                        child: state is ProductAddItemToCartButtonLoading
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'اضافه‌کردن به سبدخرید',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: faPrimaryFontFamily,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                      )),
                );
              },
            ),
            body: SafeArea(
              child: CustomScrollView(
                physics: Constant.defaultScrollPhysic,
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.width * 0.8,
                    pinned: true,
                    collapsedHeight: 56,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: ImageLoadingService(
                        imagePath: widget.productEntity.imagePath,
                      ),
                    ),
                    leading: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        CupertinoIcons.arrow_right,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    actions: [
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              context.read<ProductBloc>().add(
                                  ProductClickLikeButton(widget.productEntity));
                            },
                            customBorder: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                  state.isFavorite
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                widget.productEntity.title,
                                style: Theme.of(context).textTheme.headline6,
                              )),
                              Column(
                                children: [
                                  Text(
                                    widget.productEntity.previousPrice
                                        .toString()
                                        .addComma()
                                        .toFaNumber(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.lineThrough),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    widget.productEntity.price
                                        .toString()
                                        .addComma()
                                        .toFaNumber(),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            'این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.این کتونی شدیدا برای دویدن و راه رفتن مناسب خست و تقریبا هیچ فشار مخربی ررا نمیگذارذ و به زانو و پای شما آسیبی نمیرساند.',
                            style: TextStyle(height: 1.5),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'نظرات کاربران',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(fontSize: 16),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: const EdgeInsets.only(
                                          right: 4, left: 4)),
                                  onPressed: () {},
                                  child: const Text(
                                    'اضافه کردن نظر',
                                    style: TextStyle(fontSize: 16),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  CommentList(productId: widget.productEntity.id),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(ScaffoldMessengerState state, {required String message}) {
    state.showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(
          message,
          style: const TextStyle(
              fontFamily: faPrimaryFontFamily, color: Colors.white),
        ),
      ),
    );
  }
}
