import 'package:flutter/material.dart';
import 'package:moveme/theme.dart';

class PaymentListItem extends StatelessWidget {
  final bool money;

  PaymentListItem({this.money = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: new FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          child: new Container(
              padding: EdgeInsets.only(right: 20.0, left: 10.0),
              height: AppSizes.buttonHeight,
              decoration: BoxDecoration(
                  color: AppColors.colorWhite,
                  border: Border.all(
                      color: AppColors.colorPrimary,
                      style: BorderStyle.solid,
                      width: 1.0),
                  borderRadius: AppSizes.buttonCorner),
              child: new Row(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorBlueLight),
                    child: money
                        ? new Image(
                            image: AssetImage("assets/icons/banknote.png"))
                        : new Icon(Icons.credit_card,
                            color: AppColors.colorWhite),
                  ),
                  new SizedBox(width: 15.0),
                  new Expanded(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(money ? 'Dinheiro' : 'MasterCard',
                            style: AppTextStyle.textPurpleExtraSmallBold),
                        money ? new SizedBox() : new Text('Cartão de Crédito **** **** **** 5656',
                            style: AppTextStyle.textGreyExtraSmall),
                      ],
                    ),
                  ),
                  new Icon(Icons.arrow_forward_ios,
                      size: 16.0, color: AppColors.colorPrimary)
                ],
              ))),
    );
  }
}
