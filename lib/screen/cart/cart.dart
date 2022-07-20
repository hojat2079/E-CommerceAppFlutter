import 'dart:async';

import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/component/widget/empty_view.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:ecommerce_app/screen/auth/auth.dart';
import 'package:ecommerce_app/screen/cart/bloc/cart_bloc.dart';
import 'package:ecommerce_app/screen/cart/cart_item.dart';
import 'package:ecommerce_app/screen/cart/price_info.dart';
import 'package:ecommerce_app/screen/shipping/shipping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? _cartBloc;
  StreamSubscription<CartState>? stateSubscription;
  final RefreshController refreshController = RefreshController();
  bool successStateVisible = false;

  @override
  void initState() {
    AuthRepositoryImpl.authChangeNotifier
        .addListener(authChangeNotifyChangeListener);
    super.initState();
  }

  @override
  void dispose() {
    AuthRepositoryImpl.authChangeNotifier
        .removeListener(authChangeNotifyChangeListener);
    _cartBloc?.close();
    stateSubscription?.cancel();
    super.dispose();
  }

  void authChangeNotifyChangeListener() {
    _cartBloc?.add(
      CartAuthChanged(AuthRepositoryImpl.authChangeNotifier.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: successStateVisible
            ? AppBar(
                centerTitle: true,
                elevation: 2,
                backgroundColor: themeData.colorScheme.surface,
                title: Text(
                  'سبد خرید',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: faPrimaryFontFamily,
                      color: themeData.colorScheme.secondary),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: successStateVisible,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 72,
            child: FloatingActionButton.extended(
                onPressed: () {
                  final successState = _cartBloc?.state;
                  if (successState is CartSuccess) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShippingPage(
                              payablePrice:
                                  successState.cartResponse.payablePrice,
                              shippingCost:
                                  successState.cartResponse.shippingCost,
                              totalPrice: successState.cartResponse.totalPrice,
                            )));
                  }
                },
                label: const Center(
                  child: Text(
                    'پرداخت',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: faPrimaryFontFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                )),
          ),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            _cartBloc = CartBloc(context.read<CartRepository>());
            stateSubscription = _cartBloc?.stream.listen((state) {
              setState(() {
                successStateVisible = state is CartSuccess ||
                    state is CartRemoveItemFailed ||
                    state is CartChangeItemFailed;
              });
              if (state is CartRemoveItemFailed) {
                showSnackBar(context, message: state.message);
              }
              if (state is CartChangeItemFailed) {
                showSnackBar(context, message: state.message);
              }
              if (refreshController.isRefresh) {
                if (state is CartSuccess) {
                  refreshController.refreshCompleted();
                } else if (state is CartError) {
                  refreshController.refreshFailed();
                }
              }
            });
            _cartBloc?.add(
              CartStarted(AuthRepositoryImpl.authChangeNotifier.value),
            );
            return _cartBloc!;
          },
          child: BlocBuilder<CartBloc, CartState>(
            buildWhen: (previous, current) {
              return current is CartLoading ||
                  current is CartError ||
                  current is CartSuccess ||
                  current is CartAuthRequired ||
                  current is CartEmptyState;
            },
            builder: (context, state) {
              if (state is CartLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: themeData.colorScheme.primary,
                  ),
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(
                    state.customError.message,
                    style: themeData.textTheme.subtitle2,
                  ),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  header: ClassicHeader(
                    completeText: 'با موفقیت انجام شد',
                    refreshingText: 'در حال بروزرسانی',
                    idleText: 'برای بروزرسانی پایین بکشید',
                    failedText: 'خطای نامشخص',
                    releaseText: 'رها کنید',
                    spacing: 8,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .apply(color: Colors.grey),
                  ),
                  controller: refreshController,
                  onRefresh: () {
                    _cartBloc?.add(CartStarted(
                        AuthRepositoryImpl.authChangeNotifier.value,
                        isRefreshed: true));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 100),
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return CartItemView(
                          data: data,
                          onDeleteButtonClicked: () {
                            _cartBloc?.add(CartDeleteButtonClicked(data.id));
                          },
                          onDecreaseButtonClicked: () {
                            if (data.count == 1) {
                              showSnackBar(context,
                                  message: "محصول نمیتواند صفر باشد");
                            } else {
                              _cartBloc?.add(
                                  CartDecreaseCountItemButtonClicked(data.id));
                            }
                          },
                          onIncreaseButtonClicked: () {
                            if (data.count == 5) {
                              showSnackBar(context,
                                  message:
                                      "محصول نمیتواند بیشتر از پنج عدد باشد");
                            } else {
                              _cartBloc?.add(
                                  CartIncreaseCountItemButtonClicked(data.id));
                            }
                          },
                        );
                      } else {
                        final data = state.cartResponse;
                        return PriceInfo(
                          payablePrice: data.payablePrice,
                          shippingCost: data.shippingCost,
                          totalPrice: data.totalPrice,
                        );
                      }
                    },
                    itemCount: state.cartResponse.cartItems.length + 1,
                  ),
                );
              } else if (state is CartAuthRequired) {
                return Center(
                  child: authRequiredState(context),
                );
              } else if (state is CartEmptyState) {
                return Center(
                  child: SmartRefresher(
                    header: ClassicHeader(
                      completeText: 'با موفقیت انجام شد',
                      refreshingText: 'در حال بروزرسانی',
                      idleText: 'برای بروزرسانی پایین بکشید',
                      failedText: 'خطای نامشخص',
                      releaseText: 'رها کنید',
                      spacing: 8,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .apply(color: Colors.grey),
                    ),
                    controller: refreshController,
                    onRefresh: () {
                      _cartBloc?.add(CartStarted(
                          AuthRepositoryImpl.authChangeNotifier.value,
                          isRefreshed: true));
                    },
                    child: emptyStateWidget(context),
                  ),
                );
              } else {
                throw Exception('current cart state is not valid.');
              }
            },
          ),
        ));
  }

  Widget authRequiredState(BuildContext context) {
    return EmptyView(
        message: 'لطفا وارد حساب کاربری خود شوید.',
        image: SvgPicture.asset(
          'assets/img/auth_required.svg',
          width: 140,
        ),
        callToAction: ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const AuthScreen()));
            },
            child: const Text('ورود به حساب کاربری')));
  }

  Widget emptyStateWidget(BuildContext context) {
    return EmptyView(
      message: 'تاکنون هیچ آیتمی به سبدخرید اضافه نکرده‌اید.',
      image: SvgPicture.asset(
        'assets/img/empty_cart.svg',
        width: 200,
      ),
    );
  }

  void showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
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
