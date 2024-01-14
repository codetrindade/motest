import 'package:flutter/material.dart';
import 'package:moveme/theme.dart';

class WalkItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 60.0),
      child: new Column(
        children: <Widget>[
          new Image(image: AssetImage("assets/images/walk.png")),
          SizedBox(height: 20.0,),
          new Text('Tudo em um!', style: AppTextStyle.textWhiteSmallBold),
          SizedBox(height: 15.0,),
          new Text('Tudo que você precisa em um só app', style: AppTextStyle.textWhiteSmall),
        ],
      ),
    );
  }
}