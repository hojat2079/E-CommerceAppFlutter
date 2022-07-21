import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/entity/view_type.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:ecommerce_app/screen/home/product_item.dart';
import 'package:ecommerce_app/screen/list/sort_type_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/list_bloc.dart';

class ListScreen extends StatefulWidget {
  final SortType sortType;

  const ListScreen({Key? key, required this.sortType}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  ViewType defaultViewType = ViewType.grid;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        title: Text(
          'لیست محصولات',
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
      body: BlocProvider<ListBloc>(
        create: (context) => ListBloc(context.read<ProductRepository>())
          ..add(ListStarted(widget.sortType, defaultViewType)),
        child: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            if (state is ListSuccess) {
              return Column(
                children: [
                  SortTypeView(
                    viewType: state.viewType,
                    sortList: state.sortList,
                    sortType: state.sortType,
                    onViewTypeClicked: () {
                      context.read<ListBloc>().add(ListStarted(
                          widget.sortType,
                          state.viewType == ViewType.grid
                              ? ViewType.single
                              : ViewType.grid));
                    },
                    onSortClicked: () {
                      buildShowModalBottomSheet(
                          context: context,
                          themeData: themeData,
                          state: state,
                          onChangedSortType: (sortType) {
                            context.read<ListBloc>().add(
                                  ListStarted(
                                    sortType,
                                    state.viewType,
                                  ),
                                );
                            Navigator.of(context).pop();
                          });
                    },
                  ),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              state.viewType == ViewType.grid ? 2 : 1,
                          childAspectRatio:
                              state.viewType == ViewType.grid ? 0.65 : 0.75,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final ProductEntity item = state.products[index];
                          return ProductItem(
                            product: state.products[index],
                            borderRadius: 0,
                            isFavorite: state.favorites.contains(item.id),
                            onLikeClicked: () {
                              context
                                  .read<ListBloc>()
                                  .add(ListClickLikeButton(item));
                            },
                          );
                        }),
                  ),
                ],
              );
            } else if (state is ListLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            } else if (state is ListError) {
              return Center(
                child: Text(state.customError.message),
              );
            } else {
              throw Exception('state is not valid');
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet({
    required BuildContext context,
    required ThemeData themeData,
    required ListSuccess state,
    required Function(SortType sortType) onChangedSortType,
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(
              top: 24,
            ),
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: themeData.colorScheme.surface,
            ),
            child: Column(
              children: [
                Text(
                  'انتخاب مرتب سازی',
                  style: themeData.textTheme.headline6,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(right: 16, left: 16),
                      itemCount: state.sortList.length,
                      itemBuilder: (context, index) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              onChangedSortType(SortType.values[index]);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              margin: const EdgeInsets.only(
                                bottom: 4,
                                top: 4,
                              ),
                              decoration: index == state.sortType.index
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: themeData.colorScheme.primary,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    )
                                  : null,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16,
                                      top: 16,
                                    ),
                                    child: Text(
                                      state.sortList[index],
                                    ),
                                  ),
                                  if (state.sortType.index == index)
                                    Icon(
                                      CupertinoIcons.check_mark_circled_solid,
                                      color: themeData.colorScheme.primary,
                                    )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ));
  }
}
