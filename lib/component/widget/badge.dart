import 'package:ecommerce_app/common/extension.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final int value;

  const Badge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Visibility(
      visible: value > 0,
      child: Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: themeData.colorScheme.primary),
        child: Text(
          value.toString().toFaNumber(),
          style: themeData.textTheme.caption!
              .copyWith(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
