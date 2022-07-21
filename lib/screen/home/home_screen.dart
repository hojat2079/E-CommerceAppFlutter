import 'package:ecommerce_app/common/constant.dart';
import 'package:ecommerce_app/common/extension.dart';
import 'package:ecommerce_app/component/widget/error.dart';
import 'package:ecommerce_app/component/widget/loading.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/repository/banner_repository.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:ecommerce_app/gen/assets.gen.dart';
import 'package:ecommerce_app/screen/home/bloc/home_bloc.dart';
import 'package:ecommerce_app/screen/home/images_slider.dart';
import 'package:ecommerce_app/screen/home/product_item.dart';
import 'package:ecommerce_app/screen/list/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocProvider(
      create: (context) {
        final bloc = HomeBloc(
          productRepository: context.read<ProductRepository>(),
          bannerRepository: context.read<BannerRepository>(),
        );
        bloc.add(HomeStarted());
        return bloc;
      },
      child: Scaffold(
        body: SafeArea(child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  physics: Constant.defaultScrollPhysic,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: Assets.img.nikeLogo
                              .image(height: 18.0, fit: BoxFit.fitHeight),
                        );
                      case 2:
                        return ImageSlider(banners: state.banners);
                      case 3:
                        return _HorizontalProductList(
                          title: 'جدیدترین ها',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ListScreen(
                                        sortType: SortType.latest)));
                          },
                          productList: state.latestProduct,
                          favorites:
                              state.favoriteList.map((e) => e.id).toList(),
                        );
                      case 4:
                        return _HorizontalProductList(
                          title: 'پربازدیدترین ها',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ListScreen(
                                        sortType: SortType.popular)));
                          },
                          productList: state.popularProduct,
                          favorites:
                              state.favoriteList.map((e) => e.id).toList(),
                        );
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeLoading) {
              return LoadingWidget(
                  color: Theme.of(context).colorScheme.primary);
            } else if (state is HomeError) {
              return CustomErrorWidget(
                  error: state.error,
                  onTap: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  });
            } else {
              throw Exception('state is not supported');
            }
          },
        )),
      ),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final List<ProductEntity> productList;
  final List<int> favorites;
  final Function() onTap;

  const _HorizontalProductList({
    Key? key,
    required this.title,
    required this.productList,
    required this.onTap,
    required this.favorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(
                onPressed: onTap,
                child: const Text('مشاهده همه'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 295,
          child: ListView.builder(
              physics: Constant.defaultScrollPhysic,
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              padding: const EdgeInsets.only(left: 8, right: 8),
              itemBuilder: (context, index) {
                final ProductEntity product = productList[index];
                return ProductItem(
                  product: product,
                  onLikeClicked: () {
                    context.read<HomeBloc>().add(HomeClickLikeButton(product));
                  },
                  isFavorite: favorites.contains(product.id),
                );
              }),
        )
      ],
    );
  }
}
