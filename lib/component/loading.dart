import 'package:flutter/material.dart';

import '../theme.dart';

class LoadingCircle extends StatelessWidget {
  final bool showBackground;

  LoadingCircle({this.showBackground = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 30),
        color: showBackground ? Colors.white : Colors.transparent,
        child: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGradientPrimary))));
  }
}
