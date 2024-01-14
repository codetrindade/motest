import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/chat.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/model/ride.dart';
import 'package:moveme/model/user.dart';
import 'package:moveme/presenter/transport_detail_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/chat/chat_page.dart';
import 'package:moveme/view/ride/transport_detail/transport_detail_view.dart';

class TransportDetail extends StatefulWidget {
  final Ride model;

  TransportDetail({@required this.model});

  @override
  _TransportDetailState createState() => _TransportDetailState(model: model);
}

class _TransportDetailState extends BaseState<TransportDetail> implements TransportDetailView {
  Ride model;
  TransportDetailPresenter _presenter;

  _TransportDetailState({this.model}) {
    _presenter = new TransportDetailPresenter(this);
  }

  getDistanceColor(double distance) {
    if (distance <= 3) return AppColors.colorGreen;
    if (distance > 3 && distance <= 7)
      return AppColors.colorBlueLight;
    else
      return AppColors.colorPurple;
  }

  buttonAction() {
    if (model.id == null) {
      Util.showLoading();
      _presenter.apply(model.priceId, model.payment, model.reservations);
    } else {
      Util.showConfirm(
          context, 'Atenção', 'Tem certeza que deseja cancelar sua(s) reserva(s) nesta carona?', 'Tenho', 'Não', () {
        Util.showLoading();
        _presenter.cancelRide(model.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: AppColors.colorBlueDark,
        elevation: 0.0,
        centerTitle: true,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: new Text('Detalhes da Viagem', style: AppTextStyle.textWhiteSmallBold),
      ),
      body: Container(
        decoration: new BoxDecoration(gradient: appGradient),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: new ListView(
                children: <Widget>[
                  new Text('Origem:', style: AppTextStyle.textBlueLightSmallBold),
                  new Text(model.startAddress,
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyle.textWhiteSmallBold),
                  new Text('Destino:', style: AppTextStyle.textBlueLightSmallBold),
                  new Text(model.endAddress,
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyle.textWhiteSmallBold),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 1.0,
                  ),
                  new Row(
                    children: <Widget>[
                      new Text('Avaliação:', style: AppTextStyle.textBlueLightBoldSmall),
                      new SizedBox(width: 10.0),
                      new Image(image: AssetImage("assets/icons/man_user_branco.png"), height: 30.0),
                      new Text('4,75', style: AppTextStyle.textBlueLightBoldSmall),
                      new SizedBox(width: 10.0),
                      new Image(image: AssetImage("assets/icons/car_compact_branco.png"), height: 30.0),
                      new Text('4,9', style: AppTextStyle.textBlueLightBoldSmall),
                    ],
                  ),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
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
                                new Text(model.driverName,
                                    overflow: TextOverflow.ellipsis, style: AppTextStyle.textBlueLightBoldSmall),
                                /*new SizedBox(height: 10.0),
                                new Row(
                                  children: <Widget>[
                                    new Text('Chevette L',
                                        style: AppTextStyle.textWhiteExtraSmallBold),
                                    new SizedBox(width: 5.0),
                                    new Text(' |',
                                        style: AppTextStyle.textWhiteExtraSmallBold),
                                    new SizedBox(width: 5.0),
                                    new Text('BIH-1991',
                                        style: AppTextStyle.textWhiteExtraSmallBold),
                                    new SizedBox(width: 5.0),
                                  ],
                                ),*/
                                /*new Row(
                                  children: <Widget>[
                                    new Text(' Vermelho ',
                                        style: AppTextStyle.textWhiteExtraSmallBold),
                                    new SizedBox(width: 5.0),
                                    new Text('|',
                                        style: AppTextStyle.textWhiteExtraSmallBold),
                                    new SizedBox(width: 5.0),
                                    new Text(' 1 - 4 pessoas ',
                                        style: AppTextStyle.textWhiteExtraSmallBold),
                                  ],
                                )*/
                              ],
                            ),
                          ),
                          new SizedBox(width: 10.0),
                          new Icon(Icons.arrow_forward_ios, color: AppColors.colorWhite)
                        ],
                      )),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 1.0,
                  ),
                  new Text('Número de Reservas', style: AppTextStyle.textBlueLightBoldSmall),
                  new Text(model.reservations.toString() + ' Pessoas', style: AppTextStyle.textWhiteSmallBold),
                  new SizedBox(height: 10.0),
                  new Text('Valor', style: AppTextStyle.textBlueLightBoldSmall),
                  new Text(
                      new NumberFormat.currency(locale: 'pt_BR', name: '', symbol: 'R\$', decimalDigits: 2)
                          .format(model.price * (model.id == null ? model.reservations : 1)),
                      style: AppTextStyle.textWhiteSmallBold),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 1.0,
                  ),
                  model.id == null
                      ? new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Partida', style: AppTextStyle.textBlueLightBoldSmall),
                            new Text(model.startTime, style: AppTextStyle.textWhiteSmallBold),
                            new Text(
                              model.startAddress,
                              style: AppTextStyle.textWhiteExtraSmallBold,
                            ),
                          ],
                        )
                      : model.status == 'approved'
                          ? new Column(
                              children: <Widget>[
                                new SizedBox(height: 10.0),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    new GestureDetector(
                                      onTap: () {
                                        eventBus.fire(CreateOrOpenNewChatEvent('ride', model.ridePassengerId));
                                      },
                                      child: new Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle, border: Border.all(color: AppColors.colorWhite)),
                                        child: new Icon(MoveMeIcons.speech_bubble, color: Colors.white),
                                      ),
                                    ),
                                    new Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle, border: Border.all(color: AppColors.colorWhite)),
                                      child: new Icon(MoveMeIcons.phone_call, color: Colors.white),
                                    ),
                                    new Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle, border: Border.all(color: AppColors.colorWhite)),
                                      child: new Icon(Icons.share, color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : SizedBox(),
                  new SizedBox(height: model.distanceStart != null ? 20.0 : 0.0),
                  model.distanceStart != null
                      ? new Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle, color: getDistanceColor(model.distanceStart)),
                                child: new Icon(Icons.directions_walk, color: AppColors.colorWhite)),
                            new SizedBox(width: 10.0),
                            new Text('Há ' + model.distanceStart.toString() + ' km da sua Origem',
                                style: AppTextStyle.textWhiteSmallBold)
                          ],
                        )
                      : SizedBox(),
                  new SizedBox(
                    height: model.distanceEnd != null ? 20.0 : 0.0,
                  ),
                  model.distanceEnd != null
                      ? new Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle, color: getDistanceColor(model.distanceEnd)),
                                child: new Icon(Icons.directions_walk, color: AppColors.colorWhite)),
                            new SizedBox(width: 10.0),
                            new Text('Há ' + model.distanceEnd.toString() + ' km do seu Destino',
                                style: AppTextStyle.textWhiteSmallBold),
                          ],
                        )
                      : new SizedBox(),
                ],
              ),
            ),
            new Expanded(
              child: new FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: buttonAction,
                  child: new Container(
                      height: AppSizes.buttonHeight,
                      decoration: BoxDecoration(
                          color: model.id == null ? AppColors.colorBlueLight : AppColors.colorPurple,
                          borderRadius: AppSizes.buttonCorner),
                      child: new Center(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(model.id == null ? 'Solicitar Reserva' : 'Cancelar',
                                style: AppTextStyle.textWhiteSmallBold)
                          ],
                        ),
                      ))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onApplySuccess(ResponseServer response) {
    Util.closeLoading();
    Util.showMessage(context, 'Sucesso', 'Você se inscreveu nesta carona!');
    Navigator.of(context).pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  }

  @override
  void onCancelRideSuccess(ResponseServer response) {
    Util.closeLoading();
    Util.showMessage(context, 'Sucesso', 'Reserva cancelada com sucesso!');
  }

  @override
  void onChatSuccess(Chat data) {}
}
