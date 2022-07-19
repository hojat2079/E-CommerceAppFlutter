import 'package:ecommerce_app/common/extension.dart';
import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/data/repository/order_repository.dart';
import 'package:ecommerce_app/screen/receipt/bloc/payment_receipt_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;

  const PaymentReceiptScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: themeData.colorScheme.surface,
        title: Text(
          'رسید پرداخت',
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
      body: BlocProvider<PaymentReceiptBloc>(
        create: (context) => PaymentReceiptBloc(context.read<OrderRepository>())
          ..add(PaymentReceiptStarted(orderId)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptSuccess) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: themeData.dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          state.checkout.purchaseSuccess
                              ? 'پرداخت با موفقیت انجام شد'
                              : 'مشکلی در پرداخت بوجود آمد',
                          style: themeData.textTheme.headline6!.apply(
                            color: themeData.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'وضعیت سفارش',
                                style: themeData.textTheme.subtitle1!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                state.checkout.paymentStatus,
                                style: themeData.textTheme.subtitle2!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'مبلغ',
                                style: themeData.textTheme.subtitle1!
                                    .copyWith(fontSize: 15),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: state.checkout.payablePrice
                                          .toString()
                                          .toFaNumber()
                                          .addComma(priceLabel: false),
                                      style: themeData.textTheme.bodyText2!
                                          .copyWith(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16),
                                    ),
                                    const TextSpan(text: ' تومان'),
                                  ],
                                  style: themeData.textTheme.bodyText2!
                                      .apply(fontSizeFactor: 0.8),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Text('بازگشت به منو اصلی',
                            style: themeData.textTheme.subtitle1!.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          //todo
                        },
                        child: Text(
                          'سوابق سفارش',
                          style: themeData.textTheme.subtitle1!.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeData.colorScheme.primary),
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else if (state is PaymentReceiptLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is PaymentReceiptError) {
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
}
