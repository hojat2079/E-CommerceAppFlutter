import 'package:ecommerce_app/component/theme.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';
import 'package:ecommerce_app/di/app.dart';
import 'package:ecommerce_app/screen/auth/auth.dart';
import 'package:ecommerce_app/screen/home/home_screen.dart';
import 'package:ecommerce_app/screen/root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: providesList,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-CommerceApp',
      theme: MyAppThemeConfig.light().getTheme(),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: RootScreen(),
      ),
    );
  }
}
