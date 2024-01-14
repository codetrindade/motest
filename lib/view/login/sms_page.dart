import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moveme/app_state.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/model/token.dart';
import 'package:moveme/model/user.dart';
import 'package:moveme/presenter/sms_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/login/sms_page_view.dart';
import 'package:moveme/view/main/main_page.dart';
import 'package:provider/provider.dart';

class SmsPage extends StatefulWidget {
  final bool fromProfile;

  SmsPage({this.fromProfile = false});

  @override
  _SmsPageState createState() => _SmsPageState(fromProfile: this.fromProfile);
}

class _SmsPageState extends State<SmsPage> implements SmsPageView {
  AppBloc bloc;
  User model;
  SmsPresenter _presenter;
  final bool fromProfile;

  var _firstDigit = TextEditingController();
  var _secondDigit = TextEditingController();
  var _thirdDigit = TextEditingController();
  var _fourthDigit = TextEditingController();
  var _phone = MaskedTextController(mask: '+00 (00) 00000-0000');

  var _firstDigitFocus = FocusNode();
  var _secondDigitFocus = FocusNode();
  var _thirdDigitFocus = FocusNode();
  var _fourthDigitFocus = FocusNode();
  var _phoneFocus = FocusNode();

  bool phonePage = true;

  _SmsPageState({this.fromProfile});

  @override
  void initState() {
    super.initState();
    _presenter = SmsPresenter(this);
    Future.microtask(() {
      model = bloc.appData.user;
    });
  }

  void onSendPhone() {
    if (_phone.text.length < 8) {
      Util.showMessage(context, 'Atenção', 'Preencha corretamente o telefone');
      FocusScope.of(context).requestFocus(_phoneFocus);
      return;
    }
    Util.showLoading();
    model.phone = _phone.text;
    _presenter.confirmSms('', model.phone);
  }

  void onSendConfirmSms() {
    if (_firstDigit.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha o primeiro dígito');
      FocusScope.of(context).requestFocus(_firstDigitFocus);
      return;
    }
    if (_secondDigit.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha o segundo dígito');
      FocusScope.of(context).requestFocus(_secondDigitFocus);
      return;
    }
    if (_thirdDigit.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha o terceiro dígito');
      FocusScope.of(context).requestFocus(_thirdDigitFocus);
      return;
    }
    if (_fourthDigit.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha o quarto dígito');
      FocusScope.of(context).requestFocus(_fourthDigitFocus);
      return;
    }

    Util.showLoading();
    var code = _firstDigit.text + _secondDigit.text + _thirdDigit.text + _fourthDigit.text;
    _presenter.confirmSms(code, model.phone);
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AppBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        if (fromProfile) {
          Navigator.pop(context);
        } else {
          bloc.changeState(AppStateEnum.HOME);
          //Navigator.pushAndRemoveUntil(
          //    context, MaterialPageRoute(builder: (context) => MainPage()), ModalRoute.withName('/login'));
        }

//        setState(() {
//        _phone.text = model.phone;
//        phonePage = true;
//        });

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.colorGradientPrimary,
          elevation: 0,
          centerTitle: true,
          leading: null,
          title: Text('Verificação', style: AppTextStyle.textBoldWhiteMedium),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  if (fromProfile)
                    Navigator.pop(context);
                  else
                    bloc.changeState(AppStateEnum.HOME);
                },
                child: Text('Pular', style: AppTextStyle.textWhiteExtraSmall))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(gradient: appGradient),
          alignment: Alignment.center,
          child: phonePage
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text('Telefone', style: AppTextStyle.textWhiteSmallBold, textAlign: TextAlign.center),
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: _phone,
                        focusNode: _phoneFocus,
                        style: AppTextStyle.textWhiteExtraSmall,
                        keyboardType: TextInputType.phone,
                        onSubmitted: (String value) {},
                        decoration: InputDecoration(
                          contentPadding: AppSizes.inputPadding,
                          labelText: 'Telefone',
                          labelStyle: AppTextStyle.textWhiteSmall,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.colorWhite, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.colorWhite, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.colorWhite, width: 0.0),
                              borderRadius: BorderRadius.all(Radius.circular(18))),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox(height: 30.0)),
                    FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                        onPressed: onSendPhone,
                        child: Container(
                            height: AppSizes.buttonHeight,
                            decoration: BoxDecoration(
                                color: AppColors.colorButtonPrimary, borderRadius: BorderRadius.circular(25.0)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Verificar telefone', style: AppTextStyle.textBoldWhiteMedium)
                                ],
                              ),
                            ))),
                  ],
                )
              : Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text('Por favor, digite o código de verificação',
                        style: AppTextStyle.textWhiteSmallBold, textAlign: TextAlign.center),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: TextField(
                            controller: _firstDigit,
                            focusNode: _firstDigitFocus,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [LengthLimitingTextInputFormatter(1)],
                            onChanged: (String value) {
                              if (value.length != 0) {
                                FocusScope.of(context).requestFocus(_secondDigitFocus);
                                _secondDigit.text = '';
                              } else
                                FocusScope.of(context).requestFocus(_firstDigitFocus);
                            },
                            decoration: InputDecoration(
                              fillColor: AppColors.colorWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.colorBlueDark, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.colorBlueDark, width: 0.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Container(
                            width: 50.0,
                            child: TextField(
                              controller: _secondDigit,
                              focusNode: _secondDigitFocus,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              autofocus: false,
                              inputFormatters: [LengthLimitingTextInputFormatter(1)],
                              onChanged: (String value) {
                                if (value.length != 0) {
                                  FocusScope.of(context).requestFocus(_thirdDigitFocus);
                                  _thirdDigit.text = '';
                                } else
                                  FocusScope.of(context).requestFocus(_secondDigitFocus);
                              },
                              decoration: InputDecoration(
                                fillColor: AppColors.colorWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.colorBlueDark, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.colorBlueDark, width: 0.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Container(
                            width: 50.0,
                            child: TextField(
                              controller: _thirdDigit,
                              focusNode: _thirdDigitFocus,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              autofocus: false,
                              inputFormatters: [LengthLimitingTextInputFormatter(1)],
                              onChanged: (String value) {
                                if (value.length != 0) {
                                  FocusScope.of(context).requestFocus(_fourthDigitFocus);
                                  _fourthDigit.text = '';
                                } else
                                  FocusScope.of(context).requestFocus(_thirdDigitFocus);
                              },
                              decoration: InputDecoration(
                                fillColor: AppColors.colorWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.colorBlueDark, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.colorBlueDark, width: 0.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Container(
                            width: 50.0,
                            child: TextField(
                              controller: _fourthDigit,
                              focusNode: _fourthDigitFocus,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              autofocus: false,
                              inputFormatters: [LengthLimitingTextInputFormatter(1)],
                              onChanged: (String value) {
                                value.length != 0
                                    ? FocusScope.of(context).requestFocus(FocusNode())
                                    : FocusScope.of(context).requestFocus(_fourthDigitFocus);
                              },
                              decoration: InputDecoration(
                                fillColor: AppColors.colorWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.colorBlueDark, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.colorBlueDark, width: 0.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Text('Reenviar SMS', style: AppTextStyle.textBoldWhiteMedium, textAlign: TextAlign.center),
                    Expanded(child: SizedBox(height: 10.0)),
                    FlatButton(
                        padding: EdgeInsets.all(20.0),
                        onPressed: onSendConfirmSms,
                        child: Container(
                            height: AppSizes.buttonHeight,
                            decoration: BoxDecoration(
                                color: AppColors.colorButtonPrimary, borderRadius: BorderRadius.circular(25.0)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[Text('Verificar', style: AppTextStyle.textBoldWhiteMedium)],
                              ),
                            ))),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void onError(String error) {
    Util.closeLoading();
    Util.showMessage(context, 'Erro', error);
  }

  @override
  void onSmsSuccess(ResponseServer response) {
    Util.closeLoading();
    if (response.message == 'SMS enviado!' || phonePage == true) {
      setState(() {
        phonePage = false;
      });
    } else {
      bloc.appData.user.status = 'active';
      bloc.setUser(bloc.appData.user);
      bloc.changeState(AppStateEnum.HOME);
    }
  }
}
