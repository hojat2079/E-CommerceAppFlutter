import 'dart:async';

import 'package:ecommerce_app/common/constant.dart';
import 'package:ecommerce_app/common/extension.dart';
import 'package:ecommerce_app/component/colors.dart';
import 'package:ecommerce_app/component/widget/image_loading_service.dart';
import 'package:ecommerce_app/data/entity/banner_entity.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatefulWidget {
  final List<BannerEntity> banners;

  const ImageSlider({Key? key, required this.banners}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentPage = 0;
  late final Timer _timer;
  final PageController _controller = PageController(initialPage: 0);

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
              physics: Constant.defaultScrollPhysic,
              controller: _controller,
              itemCount: widget.banners.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _Slider(banner: widget.banners[index]);
              }),
          Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: widget.banners.length,
                  axisDirection: Axis.horizontal,
                  effect: SlideEffect(
                      spacing: 4.0,
                      radius: 4.0,
                      dotWidth: 20.0,
                      dotHeight: 3.0,
                      paintStyle: PaintingStyle.fill,
                      dotColor: LightThemeColors.dotNotActiveColor,
                      activeDotColor:
                          Theme.of(context).colorScheme.onBackground),
                ),
              ))
        ],
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    Key? key,
    required this.banner,
  }) : super(key: key);

  final BannerEntity banner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18, left: 18),
      child: ImageLoadingService(
        imagePath: banner.imageUrl,
        isShowLoading: false,
        borderRadius: 12,
      ),
    );
  }
}
