import 'package:flutter/material.dart';
import 'package:moveme/theme.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function callback;

  AppBarCustom({@required this.title, @required this.preferredSize, this.callback});

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorPrimary,
      title: Text(title, style: AppTextStyle.textBoldWhiteMedium),
      centerTitle: true,
      elevation: 0.0,
      leading: callback == null ? Container() : IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
          onPressed: () => callback()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
    );
  }
}
