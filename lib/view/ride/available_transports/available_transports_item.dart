import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/model/ride.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/view/ride/transport_detail/transport_detail.dart';

class AvailableTransportsItem extends StatelessWidget {
  final Ride model;
  final bool last;
  final String payment;
  final Function callback;

  AvailableTransportsItem(
      {@required this.model, @required this.last, @required this.payment, this.callback});

  getStatus() {
    switch(model.status) {
      case 'approved': return 'Aprovado'; break;
      case 'disapproved': return 'Recusado'; break;
      case 'pending': return 'Pendente'; break;
    }
  }

  getColorStatus() {
    switch(model.status) {
      case 'approved': return AppColors.colorGreen; break;
      case 'disapproved': return AppColors.colorPurple; break;
      case 'pending': return AppColors.colorBlueLight; break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Container(
          padding:
              EdgeInsets.only(right: 25.0, left: 25.0, top: 15.0, bottom: 15.0),
          decoration: new BoxDecoration(
              color: AppColors.colorBlueDark,
              borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.buttonCornerDouble))),
          margin: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
          child: new FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () async {
              model.payment = payment;
              var a = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new TransportDetail(model: model)));
              if (callback != null) {
                callback();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    ClipOval(
                      child: new Image(
                        image: AssetImage('assets/images/user.png'),
                        height: 60.0,
                      ),
                    ),
                    new SizedBox(width: 10.0),
                    model.id != null
                        ? new Expanded(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(model.driverName,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.textBlueLightBoldSmall),
                                new SizedBox(height: 10.0),
                                model.id == null
                                    ? new Row(
                                        children: <Widget>[
                                          new Text(
                                              new NumberFormat.currency(
                                                      locale: 'pt_BR',
                                                      name: '',
                                                      symbol: 'R\$',
                                                      decimalDigits: 2)
                                                  .format(model.price),
                                              style: AppTextStyle
                                                  .textWhiteSmallBold),
                                          new Text(' / pessoa',
                                              style:
                                                  AppTextStyle.textWhiteSmall),
                                          new SizedBox(width: 5.0),
                                        ],
                                      )
                                    : new SizedBox()
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                new SizedBox(height: 15.0),
                new Row(
                  children: <Widget>[
                    new Text('Saída',
                        style: AppTextStyle.textBlueLightSmallBold),
                    model.distanceStart != null
                        ? new Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: model.distanceStart <= 3.0
                                          ? AppColors.colorGreen
                                          : AppColors.colorTextPrimary),
                                  child: new Icon(
                                      MoveMeIcons.pedestrian_walking,
                                      color: Colors.white,
                                      size: 15.0),
                                ),
                                new SizedBox(width: 5.0),
                                new Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: model.distanceStart <= 7.0 &&
                                              model.distanceStart > 3.0
                                          ? AppColors.colorBlueLight
                                          : AppColors.colorTextPrimary),
                                  child: new Icon(
                                      MoveMeIcons.pedestrian_walking,
                                      color: Colors.white,
                                      size: 15.0),
                                ),
                                new SizedBox(width: 5.0),
                                new Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: model.distanceStart > 7.0
                                          ? AppColors.colorPurple
                                          : AppColors.colorTextPrimary),
                                  child: new Icon(
                                      MoveMeIcons.pedestrian_walking,
                                      color: Colors.white,
                                      size: 15.0),
                                ),
                              ],
                            ),
                          )
                        : new SizedBox(),
                  ],
                ),
                new SizedBox(height: 10.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(model.startTime,
                        style: AppTextStyle.textWhiteSmallBold),
                    new Text(' | ', style: AppTextStyle.textWhiteSmall),
                    new Expanded(
                        child: new Text(model.startAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.textWhiteSmall)),
                  ],
                ),
                new SizedBox(height: 5.0),
                new Container(
                  decoration: BoxDecoration(color: AppColors.colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1.0,
                ),
                new SizedBox(height: 5.0),
                new Row(
                  children: <Widget>[
                    new Text('Chegada',
                        style: AppTextStyle.textBlueLightSmallBold),
                    model.distanceEnd != null
                        ? new Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: model.distanceEnd <= 3.0
                                          ? AppColors.colorGreen
                                          : AppColors.colorTextPrimary),
                                  child: new Icon(
                                      MoveMeIcons.pedestrian_walking,
                                      color: Colors.white,
                                      size: 15.0),
                                ),
                                new SizedBox(width: 5.0),
                                new Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: model.distanceEnd <= 7.0 &&
                                              model.distanceEnd > 3.0
                                          ? AppColors.colorBlueLight
                                          : AppColors.colorTextPrimary),
                                  child: new Icon(
                                      MoveMeIcons.pedestrian_walking,
                                      color: Colors.white,
                                      size: 15.0),
                                ),
                                new SizedBox(width: 5.0),
                                new Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: model.distanceEnd > 7.0
                                          ? AppColors.colorPurple
                                          : AppColors.colorTextPrimary),
                                  child: new Icon(
                                      MoveMeIcons.pedestrian_walking,
                                      color: Colors.white,
                                      size: 15.0),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                new SizedBox(height: 10.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(model.endTime,
                        style: AppTextStyle.textWhiteSmallBold),
                    new Text(' | ', style: AppTextStyle.textWhiteSmall),
                    new Expanded(
                        child: new Text(model.endAddress,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTextStyle.textWhiteSmall)),
                  ],
                ),
                model.status != null
                    ? Column(
                        children: <Widget>[
                          new Container(
                            decoration:
                                BoxDecoration(color: AppColors.colorWhite),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            height: 1.0,
                          ),
                          Row(
                            children: <Widget>[
                              new Text(model.date,
                                  style: AppTextStyle.textWhiteSmallBold),
                              new Expanded(child: new SizedBox()),
                              new Text(
                                  new NumberFormat.currency(
                                          locale: 'pt_BR',
                                          name: '',
                                          symbol: 'R\$',
                                          decimalDigits: 2)
                                      .format(model.price),
                                  style: AppTextStyle.textWhiteSmallBold),
                            ],
                          ),
                          new Row(children: <Widget>[
                            new Container( height: 10.0, width: 10.0,
                                decoration: BoxDecoration(
                              shape: BoxShape.circle,
                                  color: getColorStatus()
                            )),
                            new SizedBox(width: 5.0),
                            new Text(getStatus(), style: AppTextStyle.textWhiteSmall),
                            new Expanded(child: new SizedBox()),
                            new Text(model.reservations.toString() + ' reservas',
                                style: AppTextStyle.textWhiteSmall),
                          ],),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        new SizedBox(height: last ? 20.0 : 0)
      ],
    );
  }
}
