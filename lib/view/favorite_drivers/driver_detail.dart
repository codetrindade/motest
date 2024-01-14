import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/theme.dart';

class DriverDetail extends StatefulWidget {
  @override
  _DriverDetailState createState() => _DriverDetailState();
}

class _DriverDetailState extends BaseState<DriverDetail> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.colorBlueDark,
          title: Text('Detalhes do Motorista', style: AppTextStyle.textBoldWhiteMedium),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
              onPressed: () => Navigator.pop(context))),
      body: Container(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(gradient: appGradient),
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(right: 15.0, left: 5.0, top: 5.0, bottom: 5.0),
                height: AppSizes.buttonHeight * 1.5,
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Image(
                        image: AssetImage('assets/images/user.png'),
                        height: 60.0,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text('Davi Vinicius Santos Silva',
                                overflow: TextOverflow.ellipsis, style: AppTextStyle.textBlueLightBoldSmall),
                          ),
                          SizedBox(height: 10.0),
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                Text('Chevette L', style: AppTextStyle.textWhiteExtraSmallBold),
                                SizedBox(width: 5.0),
                                Text(' |', style: AppTextStyle.textWhiteExtraSmallBold),
                                SizedBox(width: 5.0),
                                Text(' Vermelho ', style: AppTextStyle.textWhiteExtraSmallBold),
                                SizedBox(width: 5.0),
                                Text('|', style: AppTextStyle.textWhiteExtraSmallBold),
                                SizedBox(width: 5.0),
                                Flexible(child: Text('BIH-1991', maxLines: 1, style: AppTextStyle.textWhiteExtraSmallBold)),
                                SizedBox(width: 5.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 15.0),
            Row(
              children: <Widget>[
                Image(image: AssetImage('assets/icons/clipboard.png')),
                SizedBox(width: 10.0),
                Text(' "Extrovertido e comunicativo" ', style: AppTextStyle.textWhiteExtraSmallBold),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Text('Avaliação:', style: AppTextStyle.textBlueLightBoldSmall),
                SizedBox(width: 10.0),
                Image(image: AssetImage("assets/icons/man_user_branco.png"), height: 30.0),
                Text('4,75', style: AppTextStyle.textBlueLightBoldSmall),
                SizedBox(width: 10.0),
                Image(image: AssetImage("assets/icons/car_compact_branco.png"), height: 30.0),
                Text('4,9', style: AppTextStyle.textBlueLightBoldSmall),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              decoration: BoxDecoration(color: AppColors.colorWhite),
              height: 1.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                Image(image: AssetImage("assets/icons/speech_bubble_light.png")),
                SizedBox(width: 10.0),
                Text('Adoro conversar', style: AppTextStyle.textWhiteSmall),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Image(image: AssetImage("assets/icons/cigarette.png")),
                SizedBox(width: 10.0),
                Text('Não é permitido fumar', style: AppTextStyle.textWhiteSmall),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Image(image: AssetImage("assets/icons/music_player.png")),
                SizedBox(width: 10.0),
                Text('Adoro ouvir música', style: AppTextStyle.textWhiteSmall),
              ],
            ),
            SizedBox(height: 10.0),
            SizedBox(
              height: 8.0,
            ),
            Container(
              decoration: BoxDecoration(color: AppColors.colorWhite),
              height: 1.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text('Caronas oferecidas:', style: AppTextStyle.textBlueLightBoldSmall),
            SizedBox(width: 10.0),
            Text('19', style: AppTextStyle.textWhiteSmall),
            SizedBox(
              height: 5.0,
            ),
            Text('Membro desde:', style: AppTextStyle.textBlueLightBoldSmall),
            SizedBox(width: 10.0),
            Text('2019', style: AppTextStyle.textWhiteSmall),
            SizedBox(
              height: 8.0,
            ),
            Container(
              decoration: BoxDecoration(color: AppColors.colorWhite),
              height: 1.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text('Comentários:', style: AppTextStyle.textBlueLightBoldSmall),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorWhite, style: BorderStyle.solid, width: 1.0),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'teste, teste, teste, testeteste, teste, teste, testeteste, teste, teste, testeteste, teste, teste, testeteste, teste, teste, teste',
                      style: AppTextStyle.textWhiteSmall),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('08:00', style: AppTextStyle.textWhiteDarkExtraSmall)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
