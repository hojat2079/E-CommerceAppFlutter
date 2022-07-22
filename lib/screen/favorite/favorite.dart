import 'package:ecommerce_app/common/constant.dart';
import 'package:ecommerce_app/common/extension.dart';
import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/component/widget/empty_view.dart';
import 'package:ecommerce_app/component/widget/image_loading_service.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:ecommerce_app/screen/product/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

import 'bloc/favorite_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: themeData.colorScheme.surface,
        title: Text(
          'لیست علاقه‌مندی ها',
          style: TextStyle(
            fontSize: 18,
            fontFamily: faPrimaryFontFamily,
            color: themeData.colorScheme.secondary,
          ),
        ),
        leading: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.arrow_right,
            color: themeData.colorScheme.secondary,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => FavoriteBloc(context.read<ProductRepository>())
          ..add(FavoriteStarted()),
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteInitial) {
              return ValueListenableBuilder<Box<ProductEntity>>(
                valueListenable: state.listenable,
                builder: (context, box, child) {
                  final products = box.values.toList();
                  if (products.isEmpty) {
                    return emptyStateWidget(context);
                  } else {
                    return buildListFavoriteView(products, themeData);
                  }
                },
              );
            } else {
              throw Exception('state is not valid.');
            }
          },
        ),
      ),
    );
  }

  ListView buildListFavoriteView(
      List<ProductEntity> products, ThemeData themeData) {
    return ListView.builder(
        physics: Constant.defaultScrollPhysic,
        padding: const EdgeInsets.only(bottom: 100, top: 8),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DetailsScreen(
                  productEntity: product,
                  isFavorite: true,
                );
              }));
            },
            onLongPress: () {
              context.read<FavoriteBloc>().add(FavoriteDeleteItem(product));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 110,
                    width: 110,
                    child: ImageLoadingService(
                      imagePath: product.imagePath,
                      borderRadius: 8,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title),
                        const SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            product.previousPrice
                                .toString()
                                .addComma()
                                .toFaNumber(),
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    decoration: TextDecoration.lineThrough),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 8,
                          ),
                          child: Text(
                            product.price.toString().addComma().toFaNumber(),
                            style: themeData.textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
        });
  }

  Widget emptyStateWidget(BuildContext context) {
    return EmptyView(
      message: 'هیچ محصولی در لیست علاقه‌مندی‌ها نیست',
      image: SvgPicture.asset(
        'assets/img/no_data.svg',
        width: 200,
      ),
    );
  }
}
