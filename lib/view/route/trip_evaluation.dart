import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/base/base_view.dart';
import 'package:moveme/component/star_rating.dart';
import 'package:moveme/presenter/trip_evaluation_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';

class TripEvaluation extends StatefulWidget {
  final bool canEvaluate;
  final String name;
  final String photo;
  final String routeId;
  final String plate;
  final String model;
  final String color;

  TripEvaluation(
      {this.canEvaluate = true,
      @required this.name,
      @required this.photo,
      @required this.routeId,
      @required this.plate,
      @required this.model,
      @required this.color});

  @override
  _TripEvaluationState createState() => _TripEvaluationState(
      name: name, photo: photo, canEvaluate: canEvaluate, routeId: routeId, model: model, plate: plate, color: color);
}

class _TripEvaluationState extends BaseState<TripEvaluation> implements TripEvaluationView {
  double _ratingDriver = 5;
  double _ratingVehicle = 5;
  String name;
  String photo;
  String routeId;
  String plate;
  String model;
  String color;
  bool canEvaluate;

  var _observationDriver = TextEditingController();
  var _observationVehicle = TextEditingController();

  TripEvaluationPresenter _presenter;

  _TripEvaluationState({this.name, this.photo, this.routeId, this.canEvaluate, this.plate, this.color, this.model}) {
    _presenter = new TripEvaluationPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: AppColors.colorBlueDark,
              title: Text('Avaliação do Motorista', style: AppTextStyle.textBoldWhiteMedium),
              centerTitle: true,
              elevation: 0.0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
                  onPressed: () => Navigator.pop(context)),
            ),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: Container(
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          decoration: BoxDecoration(gradient: appGradient),
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Text('Motorista:', style: AppTextStyle.textWhiteSmallBold),
              Container(
                  padding: EdgeInsets.only(right: 15.0, left: 5.0, top: 5.0, bottom: 5.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        margin: EdgeInsets.only(right: 15.0),
                        child: photo == null || photo.isEmpty
                            ? CircleAvatar(backgroundImage: AssetImage('assets/images/user.png'))
                            : ClipOval(
                                child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/user.png',
                                    image: photo,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover),
                              ),
                      ),
                      SizedBox(height: 10.0),
                      Text(name, overflow: TextOverflow.ellipsis, style: AppTextStyle.textWhiteSmallBold),
                    ],
                  )),
              SizedBox(
                height: 15.0,
              ),
              Text('Avaliação:', style: AppTextStyle.textWhiteSmallBold),
              StarRating(
                  rating: _ratingDriver,
                  onRatingChanged: (rating) => setState(() {
                        _ratingDriver = rating;
                      }),
                  color: Colors.yellow,
                  sizeIcon: 30.0),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorWhite, style: BorderStyle.solid, width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      style: AppTextStyle.textWhiteSmall,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(255),
                      ],
                      controller: _observationDriver,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          hintText: 'Digite algo sobre o motorista',
                          hintStyle: AppTextStyle.textWhiteSmall),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: AppColors.colorWhite),
                margin: EdgeInsets.symmetric(vertical: 15.0),
                height: 1.0,
              ),
              SizedBox(height: 10.0),
              Text('Veículo:', style: AppTextStyle.textWhiteSmallBold),
              Text(model, style: AppTextStyle.textWhiteExtraSmall),
              Text(color, style: AppTextStyle.textWhiteExtraSmall),
              Text(plate, style: AppTextStyle.textWhiteExtraSmall),
              SizedBox(height: 15.0),
              Text('Avaliação:', style: AppTextStyle.textWhiteSmallBold),
              StarRating(
                  rating: _ratingVehicle,
                  onRatingChanged: (rating) => setState(() {
                        _ratingVehicle = rating;
                      }),
                  color: Colors.yellow,
                  sizeIcon: 30.0),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorWhite, style: BorderStyle.solid, width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      style: AppTextStyle.textWhiteSmall,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(255),
                      ],
                      textInputAction: TextInputAction.done,
                      controller: _observationVehicle,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          hintText: 'Digite algo sobre o veículo',
                          hintStyle: AppTextStyle.textWhiteSmall),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              canEvaluate
                  ? Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          /*FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              child: Container(
                                  height: AppSizes.buttonHeight,
                                  decoration:
                                      BoxDecoration(color: AppColors.colorPurple, borderRadius: AppSizes.buttonCorner),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Favoritar Motorista', style: AppTextStyle.textWhiteSmallBold)
                                      ],
                                    ),
                                  ))),*/
                          FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                if (_ratingDriver == 0 || _ratingVehicle == 0) return;
                                Util.showLoading();
                                _presenter.evaluate(routeId, _ratingDriver, _observationDriver.text, _ratingVehicle,
                                    _observationVehicle.text);
                              },
                              child: Container(
                                  height: AppSizes.buttonHeight,
                                  decoration:
                                      BoxDecoration(color: AppColors.colorGreen, borderRadius: AppSizes.buttonCorner),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[Text('Enviar', style: AppTextStyle.textWhiteSmallBold)],
                                    ),
                                  ))),
                        ],
                      ))
                  : SizedBox(),
            ],
          ),
        ));
  }

  @override
  void onEvaluateSuccess() {
    Navigator.pop(context);
    Util.closeLoading();
    Util.showMessage(context, 'Sucesso', 'Avaliação cadastrada, obrigado!');
  }
}

abstract class TripEvaluationView extends BaseView {
  void onEvaluateSuccess();
}
