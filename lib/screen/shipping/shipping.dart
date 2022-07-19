import 'dart:async';

import 'package:ecommerce_app/component/colors.dart';
import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/component/widget/webview.dart';
import 'package:ecommerce_app/data/entity/create_order_params_entity.dart';
import 'package:ecommerce_app/data/repository/order_repository.dart';
import 'package:ecommerce_app/screen/cart/price_info.dart';
import 'package:ecommerce_app/screen/receipt/payment_receipt.dart';
import 'package:ecommerce_app/screen/shipping/bloc/shipping_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingPage extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingPage(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  final TextEditingController _firstNameController =
      TextEditingController(text: 'حجت');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'قنبرزاده');
  final TextEditingController _phoneController =
      TextEditingController(text: '09338503075');
  final TextEditingController _postalCodeController =
      TextEditingController(text: '1234567890');
  final TextEditingController _addressController = TextEditingController(
      text: 'لار شهرجدید خیابان فرهنگ 12 بیبسبسیبسی بسیب');
  StreamSubscription<ShippingState>? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: themeData.colorScheme.surface,
        title: Text(
          'تحویل گیرنده',
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
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final shippingBloc = ShippingBloc(context.read<OrderRepository>());
          streamSubscription = shippingBloc.stream.listen((state) {
            if (state is ShippingError) {
              showSnackBar(context, message: state.customError.message);
            } else if (state is ShippingSuccess) {
              if (state.createOrderResult.bankGatewayUrl.isEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentReceiptScreen(
                          orderId: state.createOrderResult.orderId,
                        )));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WebViewUrl(
                    url: state.createOrderResult.bankGatewayUrl,
                  ),
                ));
              }
            }
          });
          return shippingBloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                maxLines: 1,
                controller: _firstNameController,
                style: const TextStyle(
                  color: LightThemeColors.primaryTextColor,
                  fontFamily: faPrimaryFontFamily,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(label: Text('نام')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                maxLines: 1,
                controller: _lastNameController,
                style: const TextStyle(
                  color: LightThemeColors.primaryTextColor,
                  fontFamily: faPrimaryFontFamily,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(label: Text('نام خانوادگی')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: LightThemeColors.primaryTextColor,
                  fontFamily: faPrimaryFontFamily,
                  fontSize: 16,
                ),
                maxLines: 1,
                decoration: const InputDecoration(label: Text('کد پستی')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _phoneController,
                maxLines: 1,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: LightThemeColors.primaryTextColor,
                  fontFamily: faPrimaryFontFamily,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(label: Text('شماره تماس')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _addressController,
                style: const TextStyle(
                  color: LightThemeColors.primaryTextColor,
                  fontFamily: faPrimaryFontFamily,
                  fontSize: 16,
                ),
                maxLines: 1,
                decoration:
                    const InputDecoration(label: Text('آدرس تحویل گیرنده')),
              ),
              const SizedBox(
                height: 12,
              ),
              PriceInfo(
                payablePrice: widget.payablePrice,
                shippingCost: widget.shippingCost,
                totalPrice: widget.totalPrice,
              ),
              const SizedBox(
                height: 12,
              ),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(CreateOrderParamsEntity(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  postalCode: _postalCodeController.text,
                                  address: _addressController.text,
                                  phoneNumber: _phoneController.text,
                                  paymentMethod: PaymentMethod.online,
                                )));
                              },
                              child: Text('پرداخت اینترنتی',
                                  style: themeData.textTheme.subtitle1!
                                      .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(CreateOrderParamsEntity(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  postalCode: _postalCodeController.text,
                                  address: _addressController.text,
                                  phoneNumber: _phoneController.text,
                                  paymentMethod: PaymentMethod.cashOnDelivery,
                                )));
                              },
                              child: Text('پرداخت در محل',
                                  style: themeData.textTheme.subtitle1!
                                      .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              themeData.colorScheme.primary)),
                            ),
                          ],
                        );
                },
              ),
              const SizedBox(
                height: 36,
              )
            ],
          ),
        ),
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
