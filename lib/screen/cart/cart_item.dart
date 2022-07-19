import 'package:ecommerce_app/common/extension.dart';
import 'package:ecommerce_app/component/widget/image_loading_service.dart';
import 'package:ecommerce_app/data/entity/cart_item_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartItemView extends StatelessWidget {
  final CartItemEntity data;

  final Function() onDeleteButtonClicked;
  final Function() onIncreaseButtonClicked;
  final Function() onDecreaseButtonClicked;

  const CartItemView(
      {Key? key,
      required this.data,
      required this.onDeleteButtonClicked,
      required this.onIncreaseButtonClicked,
      required this.onDecreaseButtonClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageLoadingService(
                    imagePath: data.productEntity.imagePath,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.productEntity.title,
                      style:
                          themeData.textTheme.subtitle2!.copyWith(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Column(
                  children: [
                    Text(
                      'تعداد',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Material(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              onTap: data.showLoadingChangeCount
                                  ? null
                                  : onIncreaseButtonClicked,
                              child: const Icon(
                                Icons.add,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Center(
                            child: data.showLoadingChangeCount
                                ? const CupertinoActivityIndicator(
                                    radius: 8,
                                  )
                                : Text(
                                    data.count.toString().toFaNumber(),
                                    style: themeData.textTheme.headline6,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Material(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              onTap: data.showLoadingChangeCount
                                  ? null
                                  : onDecreaseButtonClicked,
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      data.productEntity.previousPrice
                          .toString()
                          .addComma()
                          .toFaNumber(),
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 12,
                    ),
                    child: Text(
                      data.productEntity.price
                          .toString()
                          .addComma()
                          .toFaNumber(),
                      style: themeData.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            height: 1,
          ),
          data.showLoadingDelete
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 38,
                  child: const CupertinoActivityIndicator(),
                )
              : TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    fixedSize: Size(MediaQuery.of(context).size.width, 38),
                  ),
                  onPressed: onDeleteButtonClicked,
                  child: Text(
                    'حذف از سبد خرید',
                    style:
                        themeData.textTheme.bodyText2!.apply(color: Colors.red),
                  ),
                )
        ],
      ),
    );
  }
}
