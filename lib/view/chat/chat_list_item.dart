import 'package:flutter/material.dart';
import 'package:moveme/core/bloc/chat/chat_bloc.dart';
import 'package:moveme/model/chat.dart';
import 'package:moveme/theme.dart';
import 'package:provider/provider.dart';

class ChatListItem extends StatelessWidget {
  final Chat model;

  ChatListItem({@required this.model});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => Provider.of<ChatBloc>(context, listen: false).setConversation(this.model),
      padding: EdgeInsets.all(0),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.colorGradientPrimary, style: BorderStyle.solid, width: 1),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset("assets/icons/perfil.png", height: 40),
            SizedBox(width: 15.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(model.driver.name, style: AppTextStyle.textBlueLightSmallBold),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      model.unreadMessages > 0
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              decoration: BoxDecoration(color: AppColors.colorGradientPrimary, shape: BoxShape.circle),
                              child: Text(model.unreadMessages.toString(), style: AppTextStyle.textWhiteSmallBold))
                          : SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
