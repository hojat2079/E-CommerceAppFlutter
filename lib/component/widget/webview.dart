import 'package:ecommerce_app/screen/receipt/payment_receipt.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewUrl extends StatelessWidget {
  final String url;

  const WebViewUrl({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: url,
      onPageStarted: (newUrl) {
        final uri = Uri.parse(newUrl);
        if (uri.host == 'expertdevelopers.ir' &&
            (uri.pathSegments.contains('checkout') ||
                (uri.pathSegments.contains('Checkout')) ||
                (uri.pathSegments.contains('appCheckout')))) {
          final int orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PaymentReceiptScreen(
                orderId: orderId,
              ),
            ),
          );
        }
      },
      onWebResourceError: (error) {
        debugPrint('error loading web view, error -> ${error.description}');
      },
    );
  }
}
