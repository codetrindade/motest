import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/model/user.dart';

import '../../theme.dart';

class AvailableDriversDetail extends StatefulWidget {
  final User model;
  final bool favorite;

  AvailableDriversDetail({@required this.model, @required this.favorite});

  @override
  _AvailableDriversDetailState createState() =>
      _AvailableDriversDetailState(model: model, favorite: favorite);
}

class _AvailableDriversDetailState extends State<AvailableDriversDetail> {
  User model;
  bool favorite;

  _AvailableDriversDetailState({this.model, this.favorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom(
            title: 'Detalhe do Motorista',
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
            callback: () => Navigator.pop(context)),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(padding: EdgeInsets.only(top: 15), children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(children: [
                  ClipOval(
                      child: model.photo == null || model.photo.isEmpty
                          ? Image(image: AssetImage('assets/images/user.png'), height: 70.0)
                          : FadeInImage.assetNetwork(
                              image: model.photo,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              placeholder: 'assets/images/user.png')),
                  if (favorite)
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            margin: EdgeInsets.only(left: 0),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorPrimary),
                            child: Icon(Icons.star, size: 25.0, color: AppColors.colorWhite)))
                ]),
                SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(model.name, style: AppTextStyle.textBlueLightBoldSmall),
                    SizedBox(height: 10),
                    Text('"${model.driver.description}"', style: AppTextStyle.textGreyExtraSmall)
                  ]),
                )
              ]),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(children: [
                      Row(children: [
                        Text(model.rating, style: AppTextStyle.textGreySmall),
                        Icon(Icons.star, color: AppColors.colorPrimary, size: 15.0)
                      ]),
                      Text('${model.ratingQtt} avaliações')
                    ]),
                    Column(children: [
                      Row(children: [
                        Text(model.driver.maxStopTime.toString() + 'min ', style: AppTextStyle.textGreySmall),
                        Icon(Icons.timer, color: AppColors.colorPrimary, size: 15.0)
                      ]),
                      Text('Tempo máximo de parada')
                    ])
                  ])),
              Container(
                  color: AppColors.colorGrey,
                  child: Column(children: [
                    Container(
                        color: AppColors.colorWhite,
                        margin: EdgeInsets.only(top: 3),
                        padding: EdgeInsets.all(15),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Formas do pagamento', style: AppTextStyle.textBlueLightBoldSmall),
                          SizedBox(height: 10),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            if (model.driver.paymentMoney == 1)
                              Column(children: [
                                Icon(Icons.monetization_on, color: AppColors.colorBlueLight, size: 36),
                                Text('Dinheiro', style: AppTextStyle.textGreySmall)
                              ]),
                            if (model.driver.paymentDebit == 1)
                              Column(children: [
                                Icon(Icons.payment, color: AppColors.colorBlueLight, size: 36),
                                Text('Débito', style: AppTextStyle.textGreySmall)
                              ]),
                            if (model.driver.paymentCredit == 1)
                              Column(children: [
                                Icon(Icons.payment, color: AppColors.colorBlueLight, size: 36),
                                Text('Crédito', style: AppTextStyle.textGreySmall)
                              ])
                          ])
                        ])),
                    Container(
                        color: AppColors.colorWhite,
                        margin: EdgeInsets.only(top: 3),
                        padding: EdgeInsets.all(15),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text('Preferências', style: AppTextStyle.textBlueLightSmallBold)),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(model.driver.talk == 1 ? 'Adoro conversar!' : 'Só falo o necessário',
                                style: AppTextStyle.textThirdSmallBold),
                            Icon(Icons.chat, size: 30.0, color: AppColors.colorBlueLight)
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(
                                model.driver.smoke == 1 ? 'Cigarro não me incomoda' : 'Não é permitido fumar',
                                style: AppTextStyle.textThirdSmallBold),
                            Icon(Icons.smoke_free, size: 30.0, color: AppColors.colorBlueLight)
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(model.driver.music == 1 ? 'Adoro ouvir música!' : 'Sem música no carro',
                                style: AppTextStyle.textThirdSmallBold),
                            Icon(Icons.music_note, size: 30.0, color: AppColors.colorBlueLight)
                          ])
                        ])),
                    Container(
                        color: AppColors.colorWhite,
                        margin: EdgeInsets.only(top: 3),
                        padding: EdgeInsets.all(15),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          ClipOval(
                              child: FadeInImage.assetNetwork(
                                  image: model.vehicle.photo.file,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: 'assets/gifs/loading.gif')),
                          SizedBox(width: 10),
                          Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(model.vehicle.model, style: AppTextStyle.textBlueLightBoldSmall),
                            SizedBox(height: 10),
                            Text(model.vehicle.licensePlate, style: AppTextStyle.textGreyExtraSmall)
                          ])),
                          Column(children: [
                            Row(children: [
                              Text(model.vehicle.rating, style: AppTextStyle.textGreyExtraSmall),
                              Icon(Icons.star, color: AppColors.colorPrimary, size: 15.0)
                            ]),
                            Text('${model.vehicle.ratingQtt.toString()} avaliações')
                          ])
                        ]))
                  ]))
            ])));
  }
}
