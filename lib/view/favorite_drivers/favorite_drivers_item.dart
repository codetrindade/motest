import 'package:flutter/material.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/driver/driver_favorite_bloc.dart';
import 'package:moveme/model/user_driver.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/widgets/confirm_sheet.dart';
import 'package:provider/provider.dart';

class FavoriteDriversItem extends StatelessWidget {
  final UserDriver model;

  showConfirmSheet(BuildContext context, String driverId) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ConfirmSheet(
              onCancel: () => Navigator.pop(context),
              onConfirm: () {
                Navigator.pop(context);
                Provider.of<DriverFavoriteBloc>(context, listen: false).favoriteDriver(driverId);
              },
              text: 'Atenção\n\nTem certeza que deseja remover este motorista dos favoritos?');
        });
  }

  FavoriteDriversItem({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => DriverDetail()));
          },
          child: Container(
              padding: EdgeInsets.only(right: 15.0, left: 5.0, top: 5.0, bottom: 5.0),
              height: AppSizes.buttonHeight * 1.5,
              decoration: BoxDecoration(
                  color: AppColors.colorWhite,
                  border: Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1.0),
                  borderRadius: AppSizes.buttonCorner * 1.5),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Image(
                      image: model.photo != null ? NetworkImage(model.photo) : AssetImage('assets/images/user.png'),
                      height: 100.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(model.name, overflow: TextOverflow.ellipsis, style: AppTextStyle.textPurpleSmallBold),
                        Row(
                          children: <Widget>[
                            Image(image: AssetImage("assets/icons/man-user.png"), height: 11.0),
                            SizedBox(width: 5.0),
                            Text(model.rating, style: AppTextStyle.textGreyExtraSmall),
                            SizedBox(width: 10.0),
                            //Image(image: AssetImage("assets/icons/car_compact_roxo.png"), height: 10.0),
                            //SizedBox(width: 5.0),
                            //Text('4.9', style: AppTextStyle.textGreyExtraSmall),
                            //SizedBox(width: 5.0),
                            //Text(' | ', style: AppTextStyle.textGreyExtraSmall),
                            //SizedBox(width: 5.0),
                            //Text('Popular', style: AppTextStyle.textGreyExtraSmall),
                          ],
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     Text(' Chevette L', style: AppTextStyle.textGreyExtraSmall),
                        //     SizedBox(width: 5.0),
                        //     Text(' |', style: AppTextStyle.textGreyExtraSmall),
                        //     SizedBox(width: 5.0),
                        //     Text(' ABB-1343 ', style: AppTextStyle.textGreyExtraSmall),
                        //     SizedBox(width: 5.0),
                        //     Text('|', style: AppTextStyle.textGreyExtraSmall),
                        //     SizedBox(width: 5.0),
                        //     Flexible(
                        //       child: Text('1-4', maxLines: 1, style: AppTextStyle.textGreyExtraSmall),
                        //     ),
                        //     SizedBox(width: 5.0),
                        //     Image(image: AssetImage("assets/icons/man-user.png"), height: 11.0),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () => showConfirmSheet(context, model.id),
                      child: Icon(Icons.delete, color: AppColors.colorBlueDark, size: 25))
                ],
              ))),
    );
  }
}
