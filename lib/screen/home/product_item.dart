import 'package:ecommerce_app/common/extension.dart';
import 'package:ecommerce_app/component/widget/image_loading_service.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/screen/product/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.product,
    this.borderRadius = 0,
    this.itemWidth = 176,
    this.itemHeight = 189,
  }) : super(key: key);

  final ProductEntity product;
  final double borderRadius;
  final double itemWidth;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DetailsScreen(productEntity: product);
            }));
          },
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            width: itemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.93,
                      child: ImageLoadingService(
                        imagePath: product.imagePath,
                        borderRadius: borderRadius,
                      ),
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle),
                          child: const Icon(
                            CupertinoIcons.heart,
                            size: 18,
                          ),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    product.previousPrice.toString().addComma().toFaNumber(),
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: Text(product.price.toString().addComma().toFaNumber()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
