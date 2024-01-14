import 'dart:ui';

import 'package:flutter/material.dart';

final ThemeData appTheme = new ThemeData(
    platform: TargetPlatform.android,
    fontFamily: 'Intelo',
    primaryColor: AppColors.colorPrimary,
    primaryColorDark: AppColors.colorPrimary,
    //buttonColor: AppColors.colorSecondary,
    //accentColor: Colors.grey,
    canvasColor: Colors.white,
    backgroundColor: Colors.white);

final LinearGradient appGradient = new LinearGradient(
    colors: [AppColors.colorGradientPrimary, AppColors.colorGradientSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);

class AppColors {
  static const colorGradientPrimary = const Color(0xFF2A7EF6);
  static const colorGradientSecondary = const Color(0xFF3BC0FF);

  static const colorWhite = const Color(0xFFffffff);

  static const colorPrimary = const Color(0xFF2A7EF6);
  static const colorPrimaryLight = const Color(0xFF38C0FF);
  static const colorButtonPrimary = const Color(0xFF00E787);

  static const colorPurple = const Color(0xFFc54ce2);
  static const colorBlueLight = const Color(0xFF5ea1fe);
  static const colorBlueDark = const Color(0xFF2A7EF6);
  static const colorGreen = const Color(0xFF7AD06D);

  static const colorTextWhite = const Color(0xFFffffff);
  static const colorTextGreyLight = const Color(0xFFf8f8f8);
  static const colorTextPrimary = const Color(0xFFd2cfcf);
  static const colorTextSecondary = const Color(0xFF808080);
  static const colorTextThird = const Color(0xFF787878);
  static const colorGrey = const Color(0xFFd2cfcf);
}

class AppSizes {
  static const fontExtraSmall = 14.0;
  static const fontSmall = 16.0;
  static const fontMedium = 18.0;
  static const fontBig = 20.0;

  static var inputPadding = EdgeInsets.all(15.0);
  static var inputPaddingHorizontalDouble = 20.0;
  static var inputPaddingVerticalDouble = 15.0;
  static var inputRadiusDouble = 20.0;

  static var buttonHeight = 50.0;
  static var buttonCorner = BorderRadius.circular(25.0);
  static var buttonCornerDouble = 25.0;

  static var logoMarginTop = 0.1;
}

class AppFont {
  static const fontMontserrat = "Montserrat";
}

class AppRadius {
  static var bottomRadius = Radius.circular(30.0);
  static var containerRadius = Radius.circular(15.0);
  static var inputRadius = Radius.circular(5.0);
}

class AppTextStyle {
  static const textWhiteExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorTextWhite);

  static const textWhiteSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorTextWhite);

  static const textWhiteSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorTextWhite);

  static const textWhiteBigBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontBig,
      color: AppColors.colorTextWhite);

  static const textBoldWhiteMedium = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontMedium,
      color: AppColors.colorTextWhite);

  static const textWhiteExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorTextWhite);

  static const textPurpleExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorPrimary);

  static const textPurpleSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorPrimaryLight);

  static const textPurpleSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorPrimaryLight);

  static const textPurpleExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorPrimaryLight);

  static const textGreyExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorTextSecondary);

  static const textGreySmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorTextSecondary);

  static const textWhiteDarkExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorTextPrimary);

  static const textGreyExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorTextSecondary);

  static const textGreySmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorTextSecondary);

  static const textBlueLightSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorBlueLight);

  static const textBlueLightExtraSmall =
      TextStyle(fontFamily: AppFont.fontMontserrat, fontSize: AppSizes.fontExtraSmall, color: AppColors.colorBlueLight);

  static const textBlueLightExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorBlueLight);

  static const textBlueLightBoldSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorBlueLight);

  static const textBlueLightMediumBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontMedium,
      color: AppColors.colorBlueLight);

  static const textBlueLightSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorBlueLight);

  static const textBlueLightBoldExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorBlueLight);

  static const textBlueBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorBlueDark);

  static const textGreenBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorGreen);

  static const textGreyDarkSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorTextThird);

  static const textBlueDarkBoldMedium = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontMedium,
      color: AppColors.colorBlueDark);

  static var textThirdSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorTextThird);

  static var textThirdExtraSmall =
      TextStyle(fontFamily: AppFont.fontMontserrat, fontSize: AppSizes.fontExtraSmall, color: AppColors.colorTextThird);

  static var textThirdExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorTextThird);

  static var textThirdBoldSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorTextThird);

  static var textThirdBoldExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorTextThird);
}
