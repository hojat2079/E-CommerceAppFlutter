import 'package:ecommerce_app/common/extension.dart';
import 'package:flutter/material.dart';

class PriceInfo extends StatelessWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const PriceInfo(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
        left: 8,
        top: 24,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'جزئیات خرید',
            style: themeData.textTheme.subtitle1!.copyWith(fontSize: 16),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: themeData.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('مبلغ کل خرید',
                          style: themeData.textTheme.bodyText2!
                              .copyWith(fontSize: 15)),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: totalPrice
                                  .toString()
                                  .toFaNumber()
                                  .addComma(priceLabel: false),
                              style: themeData.textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w700, fontSize: 16),
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
                const Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'هزینه ارسال',
                        style: themeData.textTheme.bodyText2!
                            .copyWith(fontSize: 15),
                      ),
                      shippingCost > 0
                          ? RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: shippingCost
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
                            )
                          : Text(
                              'رایگان',
                              style: themeData.textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            )
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('مبلغ قابل پرداخت',
                          style: themeData.textTheme.bodyText2!
                              .copyWith(fontSize: 15)),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: payablePrice
                                  .toString()
                                  .toFaNumber()
                                  .addComma(priceLabel: false),
                              style: themeData.textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                            const TextSpan(text: ' تومان'),
                          ],
                          style: themeData.textTheme.bodyText2!
                              .apply(fontSizeFactor: 0.8),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
