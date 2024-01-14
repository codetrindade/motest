import 'package:flutter/material.dart';
import 'package:moveme/theme.dart';

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary)),
      ),
    );
  }
}
