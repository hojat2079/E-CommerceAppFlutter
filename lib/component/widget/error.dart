import 'package:ecommerce_app/common/custom_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final CustomError error;
  final Function() onTap;

  const CustomErrorWidget({Key? key, required this.error, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(error.message),
          ElevatedButton(onPressed: onTap, child: const Text('تلاش دوباره'))
        ],
      ),
    );
  }
}
