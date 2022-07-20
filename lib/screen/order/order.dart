import 'package:ecommerce_app/common/constant.dart';
import 'package:ecommerce_app/common/extension.dart';
import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/component/widget/empty_view.dart';
import 'package:ecommerce_app/component/widget/image_loading_service.dart';
import 'package:ecommerce_app/data/repository/order_repository.dart';
import 'package:ecommerce_app/screen/order/bloc/order_history_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: themeData.colorScheme.surface,
        title: Text(
          'سوابق سفارش',
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
      body: BlocProvider<OrderHistoryBloc>(
        create: (context) {
          return OrderHistoryBloc(context.read<OrderRepository>())
            ..add(
              OrderHistoryStarted(),
            );
        },
        child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is OrderHistorySuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final item = state.orders[index];
                  return Container(
                    margin: const EdgeInsets.only(
                        right: 16, left: 16, bottom: 8, top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: themeData.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('شناسه سفارش'),
                              Text(item.id.toString().toFaNumber()),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('مبلغ'),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: item.payablePrice
                                          .toString()
                                          .toFaNumber()
                                          .addComma(priceLabel: false),
                                      style: themeData.textTheme.bodyText2!
                                          .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                    ),
                                    const TextSpan(text: ' تومان'),
                                  ],
                                  style: themeData.textTheme.bodyText2!
                                      .apply(fontSizeFactor: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        SizedBox(
                          height: 132,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: Constant.defaultScrollPhysic,
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                              itemCount: item.products.length,
                              itemBuilder: (context, index2) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  margin:
                                      const EdgeInsets.only(right: 4, left: 4),
                                  child: ImageLoadingService(
                                    borderRadius: 8,
                                    imagePath: item.products[index2].imagePath,
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  );
                },
                itemCount: state.orders.length,
              );
            } else if (state is OrderHistoryError) {
              return Center(
                child: Text(state.customError.message),
              );
            } else if (state is OrderHistoryEmpty) {
              return Center(
                child: emptyStateWidget(context),
              );
            } else {
              throw Exception('state is not valid.');
            }
          },
        ),
      ),
    );
  }

  Widget emptyStateWidget(BuildContext context) {
    return EmptyView(
      message: 'هیچ سابقه فروشی وجود ندارد',
      image: SvgPicture.asset(
        'assets/img/no_data.svg',
        width: 200,
      ),
    );
  }
}
