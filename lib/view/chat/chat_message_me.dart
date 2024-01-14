import 'package:flutter/material.dart';
import 'package:moveme/model/chat_message.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';

class ChatMessageMe extends StatelessWidget {
  final ChatMessage message;

  ChatMessageMe({this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
              color: AppColors.colorBlueLight,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Flexible(
                  child: new Text(message.message,
                      style: AppTextStyle.textWhiteSmall)),
              new SizedBox(width: 15.0),
              new Text(Util.getMessageTime(message.createdAt),
                  style: AppTextStyle.textWhiteExtraSmall,
                  textAlign: TextAlign.right)
            ],
          ),
        ),
      ],
    );
  }
}
