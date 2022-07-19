import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoadingService extends StatelessWidget {
  final String imagePath;
  final IconData? errorIcon;
  final bool isShowLoading;
  final double borderRadius;

  const ImageLoadingService(
      {Key? key,
      required this.imagePath,
      this.errorIcon,
      this.isShowLoading = false,
      this.borderRadius = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imagePath,
        placeholder: (context, url) => isShowLoading
            ? SizedBox(
                width: 50,
                height: 50,
                child: LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : const SizedBox.shrink(),
        errorWidget: (context, url, error) {
          return errorIcon != null ? Icon(errorIcon) : const SizedBox.shrink();
        },
      ),
    );
  }
}
