import 'package:ecommerce_app/component/colors.dart';
import 'package:ecommerce_app/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

const String faPrimaryFontFamily = FontFamily.iranYekan;

class MyAppThemeConfig {
  static const defaultTextStyle = TextStyle(
    fontFamily: faPrimaryFontFamily,
    fontSize: 14,
    color: LightThemeColors.primaryTextColor,
  );

  final Brightness brightness;
  final Color primaryColor = LightThemeColors.primaryColor;
  final Color secondaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color surfaceColor;
  final Color scaffoldBackgroundColor;
  final Color appbarColor;

  MyAppThemeConfig.light()
      : brightness = Brightness.light,
        secondaryColor = LightThemeColors.secondaryColor,
        primaryTextColor = LightThemeColors.primaryTextColor,
        secondaryTextColor = LightThemeColors.secondaryTextColor,
        surfaceColor = Colors.white,
        appbarColor = Colors.white,
        scaffoldBackgroundColor = Colors.white;

  ThemeData getTheme() {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryTextColor.withOpacity(0.1),
          ),
        ),
      ),
      hintColor: secondaryTextColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        onPrimary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appbarColor,
        foregroundColor: primaryTextColor,
      ),
      iconTheme: IconThemeData(
        color: secondaryColor,
      ),
      textTheme: TextTheme(
        subtitle1: defaultTextStyle.apply(color: secondaryTextColor),
        subtitle2: defaultTextStyle,
        button: defaultTextStyle,
        bodyText2: defaultTextStyle,
        bodyText1: defaultTextStyle.copyWith(fontSize: 15),
        headline6: defaultTextStyle.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        headline4: defaultTextStyle.copyWith(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        caption: defaultTextStyle.apply(
          color: secondaryTextColor,
        ),
      ),
    );
  }
}
