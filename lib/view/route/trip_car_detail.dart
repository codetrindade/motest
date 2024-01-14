import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/preview.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/view/route/trip_payment.dart';
import 'package:moveme/view/route/trip_route_item.dart';

import 'package:moveme/view/route/active_trip/active_trip.dart';

class TripCarDetail extends StatefulWidget {
  final List<Address> routes;
  final PreviewItem model;

  TripCarDetail({@required this.routes, @required this.model});

  @override
  _TripCarDetailState createState() => _TripCarDetailState(routes: routes, model: model);
}

class _TripCarDetailState extends BaseState<TripCarDetail> {

  List<Address> routes;
  PreviewItem model;

  _TripCarDetailState({this.routes, this.model});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(decoration: new BoxDecoration(gradient: appGradient)),
          new Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0))),
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04),
                  new Text('Detalhes da Corrida',
                      style: AppTextStyle.textBoldWhiteMedium)
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
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.14,
                left: 20.0,
                right: 20.0),
            child: new ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text('Avaliação:',
                        style: AppTextStyle.textBlueLightBoldSmall),
                    new SizedBox(width: 10.0),
                    new Image(
                        image: AssetImage("assets/icons/man_user_branco.png"),
                        height: 30.0),
                    new Text('4,75',
                        style: AppTextStyle.textBlueLightBoldSmall),
                    new SizedBox(width: 10.0),
                    new Image(
                        image:
                            AssetImage("assets/icons/car_compact_branco.png"),
                        height: 30.0),
                    new Text('4,9', style: AppTextStyle.textBlueLightBoldSmall),
                  ],
                ),
                new Container(
                  decoration: BoxDecoration(color: AppColors.colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  height: 1.0,
                ),
                new Container(
                    height: AppSizes.buttonHeight * 1.5,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ClipOval(
                          child: new Image(
                            image: AssetImage('assets/images/user.png'),
                            height: 60.0,
                          ),
                        ),
                        new SizedBox(width: 10.0),
                        new Expanded(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(model.user.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.textBlueLightBoldSmall),
                              /*new SizedBox(height: 10.0),
                              new Row(
                                children: <Widget>[
                                  new Text('Chevette L',
                                      style:
                                          AppTextStyle.textWhiteExtraSmallBold),
                                  new SizedBox(width: 5.0),
                                  new Text(' |',
                                      style:
                                          AppTextStyle.textWhiteExtraSmallBold),
                                  new SizedBox(width: 5.0),
                                  new Text('BIH-1991',
                                      style:
                                          AppTextStyle.textWhiteExtraSmallBold),
                                  new SizedBox(width: 5.0),
                                ],
                              ),*/
                              /*new Row(
                                children: <Widget>[
                                  new Text(' Vermelho ',
                                      style:
                                          AppTextStyle.textWhiteExtraSmallBold),
                                  new SizedBox(width: 5.0),
                                  new Text('|',
                                      style:
                                          AppTextStyle.textWhiteExtraSmallBold),
                                  new SizedBox(width: 5.0),
                                  new Text(' 1 - 4 pessoas ',
                                      style:
                                          AppTextStyle.textWhiteExtraSmallBold),
                                ],
                              )*/
                            ],
                          ),
                        ),
                        new SizedBox(width: 10.0),
                        new Icon(Icons.arrow_forward_ios,
                            color: AppColors.colorWhite)
                      ],
                    )),
                new Container(
                  decoration: BoxDecoration(color: AppColors.colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  height: 1.0,
                ),
                new Text('Localização do motorista:',
                    style: AppTextStyle.textBlueLightBoldSmall),
                new Text(model.driverDistance + ' / ' + model.driverDuration,
                    style: AppTextStyle.textWhiteSmall),
                new Container(
                  decoration: BoxDecoration(color: AppColors.colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  height: 1.0,
                ),
                new TripRouteItem(routes: routes),
                new Container(
                  decoration: BoxDecoration(color: AppColors.colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  height: 1.0,
                ),
                new Row(
                  children: <Widget>[
                    new Text('Valor: ',
                        style: AppTextStyle.textWhiteSmallBold),
                    /*new Text('Popular / ',
                        style: AppTextStyle.textWhiteSmallBold),*/
                    new Text(new NumberFormat.currency(
                        locale: 'pt_BR',
                        name: '',
                        symbol: 'R\$',
                        decimalDigits: 2)
                        .format(model.price),
                        style: AppTextStyle.textBlueLightSmallBold),
                  ],
                ),
                new FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new TripPayment()));
                    },
                    child: new Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                              color: AppColors.colorWhite,
                              style: BorderStyle.solid,
                              width: 1)),
                      child: new Row(
                        children: <Widget>[
                          new Image(
                              image: AssetImage('assets/icons/banknote.png')),
                          new SizedBox(width: 20.0),
                          new Expanded(
                            child: new Text('Dinheiro',
                                style: AppTextStyle.textWhiteSmallBold),
                          ),
                          new Icon(Icons.arrow_forward_ios,
                              color: AppColors.colorWhite)
                        ],
                      ),
                    )),
                new Container(
                  decoration: BoxDecoration(color: AppColors.colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  height: 1.0,
                ),
                new FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ActiveTrip()));
                    },
                    child: new Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                        height: AppSizes.buttonHeight,
                        decoration: BoxDecoration(
                            color: AppColors.colorBlueLight,
                            borderRadius: AppSizes.buttonCorner),
                        child: new Center(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text('Confirmar Corrida',
                                  style: AppTextStyle.textWhiteSmallBold)
                            ],
                          ),
                        )))
              ],
            ),
          )
        ],
      ),
    );
  }
}
