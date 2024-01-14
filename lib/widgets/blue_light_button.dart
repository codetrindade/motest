import 'package:flutter/material.dart';
import 'package:moveme/theme.dart';

class BlueLightButton extends StatelessWidget {
  final String text;
  final Function callback;

  BlueLightButton({@required this.text, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () => callback(),
        child: Container(
            height: AppSizes.buttonHeight,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(color: AppColors.colorBlueLight, borderRadius: AppSizes.buttonCorner),
            child: Center(child: Text(text, style: AppTextStyle.textWhiteSmallBold))));
  }
}
