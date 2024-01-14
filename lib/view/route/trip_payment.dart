import 'package:flutter/material.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/view/payment/card_page.dart';
import 'package:moveme/view/payment/payment_list_item.dart';

class TripPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
              decoration: new BoxDecoration(
                  color: AppColors.colorWhite
              )),
          new Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
                color: AppColors.colorPrimary,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))
            ),
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  new Text('Cartões', style: AppTextStyle.textBoldWhiteMedium)
                ],
              ),
            ),
          ),
          new Container(
            margin: EdgeInsets.only(top: 30.0),
            child: new IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: AppColors.colorWhite, size: 16.0),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          new Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, left: 20.0, right: 20.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: AppColors.colorPrimary,
                      style: BorderStyle.solid,
                      width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(40.0)
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Image(image: AssetImage("assets/icons/hand.png")),
                      new SizedBox(width: 20.0),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Detalhes do pagamento', style: AppTextStyle.textPurpleExtraSmallBold),
                            new Row(children: <Widget>[
                              new Text('Categoria: ', style: AppTextStyle.textPurpleExtraSmallBold),
                              new Text('Popular: / ', style: AppTextStyle.textGreyExtraSmall),
                              new Text('R\$ 6,50', style: AppTextStyle.textPurpleExtraSmallBold),
                            ], ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: AppColors.colorPrimary,
                  height: 1,
                  margin: EdgeInsets.only(top: 20.0, bottom: 0.0),
                ),
                new Expanded(
                  child: new ListView(
                    padding: EdgeInsets.all(0),
                    children: <Widget>[
                      new SizedBox(height: 20.0),
                      PaymentListItem(money: true),
                      PaymentListItem(),
                      PaymentListItem(),
                      PaymentListItem(),
                      PaymentListItem(),
                      PaymentListItem(),
                      PaymentListItem(),
                      PaymentListItem(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: new Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: new Column(
          children: <Widget>[
            new FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => new CardPage()));
                },
                child: new Container(
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: AppSizes.buttonCorner),
                    child: new Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text('Adicionar cartão',
                              style: AppTextStyle.textWhiteExtraSmallBold)
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
