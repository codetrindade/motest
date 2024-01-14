import 'package:flutter/material.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/history/history_bloc.dart';
import 'package:moveme/model/route_history.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:provider/provider.dart';

class HistoryListItem extends StatelessWidget {
  final RouteHistory model;

  HistoryListItem({@required this.model});

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<HistoryBloc>(context);

    return FlatButton(
        onPressed: () async => await bloc.getRouteHistoryById(model.id),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            margin: EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.colorBlueDark, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Center(
                  child: Container(
                      height: 80,
                      width: 80,
                      margin: EdgeInsets.only(right: 15.0),
                      child: model.driver.photo == null || model.driver.photo.isEmpty
                          ? CircleAvatar(backgroundImage: AssetImage('assets/images/user.png'))
                          : ClipOval(
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/user.png', image: model.driver.photo, fit: BoxFit.cover)))),
              SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text(model.driver.name, style: AppTextStyle.textBlueLightSmallBold),
                  SizedBox(height: 5.0),
                  if (model.status != 'canceled')
                    if (model.ratingDriver == null)
                      SizedBox()
                    else
                      Row(children: <Widget>[
                        Icon(MoveMeIcons.man_user, color: AppColors.colorPurple, size: 15),
                        SizedBox(width: 10.0),
                        Text(model.ratingDriver.toStringAsFixed(1), style: AppTextStyle.textPurpleSmallBold),
                        SizedBox(width: 10.0),
                        Icon(MoveMeIcons.car_compact, color: AppColors.colorPurple, size: 15),
                        SizedBox(width: 10.0),
                        Text(model.ratingVehicle.toStringAsFixed(1), style: AppTextStyle.textPurpleSmallBold),
                      ])
                ]),
                if (model.status != 'canceled') SizedBox(width: 10),
                if (model.status != 'canceled')
                  InkWell(
                      onTap: () async => await bloc.favoriteDriver(model.driver.id),
                      child: Icon(model.isDriverFavorite ? MoveMeIcons.star_o : MoveMeIcons.star, color: Colors.yellow, size: 25))
              ]),
              Container(height: 1.0, margin: EdgeInsets.symmetric(vertical: 10.0), color: AppColors.colorBlueDark),
              Text('Origem', style: AppTextStyle.textBlueLightSmallBold),
              Text(model.points.first.address, style: AppTextStyle.textPurpleSmall),
              SizedBox(height: 10.0),
              Text('Destino', style: AppTextStyle.textBlueLightSmallBold),
              Text(model.points.last.address, style: AppTextStyle.textPurpleSmall),
              Container(height: 1.0, margin: EdgeInsets.symmetric(vertical: 10.0), color: AppColors.colorBlueDark),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Text(model.createdAt, style: AppTextStyle.textPurpleExtraSmallBold),
                model.status == 'canceled'
                    ? Expanded(
                        child: new Text('Cancelada', style: AppTextStyle.textPurpleExtraSmallBold, textAlign: TextAlign.right))
                    : Text(Util.formatMoney(model.price), style: AppTextStyle.textPurpleExtraSmallBold)
              ])
            ])));
  }
}
