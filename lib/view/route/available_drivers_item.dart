import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:moveme/model/preview.dart';
import 'package:moveme/theme.dart';

import 'available_drivers_detail.dart';

class AvailableDriversItem extends StatelessWidget {
  final PreviewItem model;
  final AvailableDriverListener listener;

  AvailableDriversItem({@required this.model, @required this.listener});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () => listener.onChosen(model.user.id),
            child: Container(
                padding: EdgeInsets.only(right: 15.0, left: 5.0, top: 5.0, bottom: 5.0),
                decoration: model.chosen
                    ? BoxDecoration(
                        color: AppColors.colorBlueDark,
                        border:
                            Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1.0),
                        borderRadius: AppSizes.buttonCorner * 3)
                    : BoxDecoration(
                        color: AppColors.colorWhite,
                        border:
                            Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1.0),
                        borderRadius: AppSizes.buttonCorner * 3),
                child: Row(children: <Widget>[
                  Stack(children: [
                    ClipOval(
                        child: model.user.photo == null || model.user.photo.isEmpty
                            ? Image(image: AssetImage('assets/images/user.png'), height: 70.0)
                            : FadeInImage.assetNetwork(
                                image: model.user.photo,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                placeholder: 'assets/images/user.png')),
                    if (model.favorite)
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: model.chosen
                              ? Container(
                                  margin: EdgeInsets.only(left: 0),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle, color: AppColors.colorWhite),
                                  child: Icon(Icons.star, size: 25.0, color: AppColors.colorPrimary))
                              : Container(
                                  margin: EdgeInsets.only(left: 0),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle, color: AppColors.colorPrimary),
                                  child: Icon(Icons.star, size: 25.0, color: AppColors.colorWhite)))
                  ]),
                  SizedBox(width: 10.0),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Text(model.user.name,
                            overflow: TextOverflow.ellipsis,
                            style: model.chosen
                                ? AppTextStyle.textWhiteSmallBold
                                : AppTextStyle.textPurpleSmallBold),
                        SizedBox(
                          height: 5,
                        ),
                        Row(children: <Widget>[
                          Icon(Icons.person,
                              color: model.chosen ? AppColors.colorWhite : AppColors.colorPrimary,
                              size: 15.0),
                          Text(model.user.rating + ' | ',
                              style: model.chosen
                                  ? AppTextStyle.textWhiteExtraSmall
                                  : AppTextStyle.textGreyExtraSmall),
                          Icon(Icons.location_on,
                              color: model.chosen ? AppColors.colorWhite : AppColors.colorPrimary,
                              size: 15.0),
                          Text(model.driverDistance + ' | ',
                              style: model.chosen
                                  ? AppTextStyle.textWhiteExtraSmall
                                  : AppTextStyle.textGreyExtraSmall),
                          Text(
                              NumberFormat.currency(
                                      locale: 'pt_BR', name: '', symbol: 'R\$', decimalDigits: 2)
                                  .format(model.price),
                              style: model.chosen
                                  ? AppTextStyle.textWhiteExtraSmallBold
                                  : AppTextStyle.textPurpleExtraSmallBold)
                        ]),
                        SizedBox(height: 5),
                        Row(children: <Widget>[
                          Text(model.user.vehicle.licensePlate + ' | ',
                              style: model.chosen
                                  ? AppTextStyle.textWhiteExtraSmall
                                  : AppTextStyle.textGreyExtraSmall),
                          Expanded(
                              child: Text(model.user.vehicle.model,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: model.chosen
                                      ? AppTextStyle.textWhiteExtraSmall
                                      : AppTextStyle.textGreyExtraSmall))
                        ])
                      ])),
                  InkWell(
                      child: Icon(Icons.more_vert,
                          size: 20.0, color: model.chosen ? AppColors.colorWhite : AppColors.colorPrimary),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AvailableDriversDetail(model: model.user, favorite: model.favorite))))
                ]))));
  }
}

abstract class AvailableDriverListener {
  void onChosen(String id);
}
