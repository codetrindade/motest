import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:moveme/component/loading.dart';
import 'package:moveme/core/bloc/login/login_bloc.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/informations/term.dart';
import 'package:moveme/widgets/text_field_custom.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc bloc;

  var _email = TextEditingController();
  var _password = TextEditingController();
  var _emailFocus = FocusNode();
  var _passwordFocus = FocusNode();

  Future<void> btnLoginAction() async {
    if (_email.text.isEmpty && !_email.text.contains('@')) {
      bloc.dialogService.showDialog('Atenção', 'Digite um email válido');
      FocusScope.of(context).requestFocus(_emailFocus);
      return;
    }

    if (_password.text.isEmpty) {
      bloc.dialogService.showDialog('Atenção', 'Digite a senha');
      FocusScope.of(context).requestFocus(_passwordFocus);
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    await bloc.login(_email.text, _password.text);
  }

  // forgot
  Future<void> onForgot() async {
    if (_email.text.length == 0 || !_email.text.contains('@') && !_email.text.contains('.')) {
      Util.showMessage(context, 'Atenção', 'Informe seu email');
      FocusScope.of(context).requestFocus(_emailFocus);
      return;
    }

    await bloc.forgot(_email.text);
  }

  openRegisterPage() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push(context, MaterialPageRoute(builder: (context) => TermPage(edit: true)));
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      bloc.showPassword = false;
      bloc.refresh();
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<LoginBloc>(context);
    return bloc.isLoading
        ? LoadingCircle(showBackground: true)
        : Scaffold(
            backgroundColor: AppColors.colorWhite,
            body: KeyboardAvoider(
              autoScroll: true,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(gradient: appGradient),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * AppSizes.logoMarginTop),
                            child: Center(child: SvgPicture.asset('assets/svg/icon_home.svg', width: 280))),
                        SizedBox(height: 20),
                        Container(
                            height: 280,
                            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
                            decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                borderRadius: BorderRadius.all(AppRadius.containerRadius),
                                border: Border.all(color: AppColors.colorPrimaryLight)),
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(children: <Widget>[
                                  SizedBox(height: 30.0),
                                  TextFieldCustom(
                                      controller: _email,
                                      focus: _emailFocus,
                                      label: 'E-mail',
                                      capitalization: TextCapitalization.none,
                                      nextFocus: _passwordFocus,
                                      keyBoardType: TextInputType.emailAddress),
                                  SizedBox(height: 10.0),
                                  TextFieldCustom(
                                      controller: _password,
                                      focus: _passwordFocus,
                                      label: 'Senha',
                                      onSubmitted: () async => await btnLoginAction(),
                                      obscureText: !bloc.showPassword,
                                      suffix: InkWell(
                                          child: Icon(!bloc.showPassword ? Icons.remove_red_eye : Icons.cancel,
                                              color: AppColors.colorBlueLight),
                                          onTap: () {
                                            bloc.showPassword = !bloc.showPassword;
                                            bloc.refresh();
                                          }),
                                      action: TextInputAction.done),
                                  Container(
                                      alignment: Alignment.topRight,
                                      child: FlatButton(
                                          onPressed: onForgot,
                                          child: Text('Esqueci a senha', style: AppTextStyle.textGreySmall))),
                                  FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () async => await btnLoginAction(),
                                      child: Container(
                                          height: AppSizes.buttonHeight,
                                          decoration: BoxDecoration(
                                              color: AppColors.colorButtonPrimary, borderRadius: AppSizes.buttonCorner),
                                          child: Center(
                                              child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[Text('Entrar', style: AppTextStyle.textWhiteSmallBold)],
                                          )))),
                                ]))),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                              Text('Não tem uma conta?', style: AppTextStyle.textWhiteSmall),
                              FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: openRegisterPage,
                                  child: Text(' Criar Conta', style: AppTextStyle.textBoldWhiteMedium))
                            ]))
                      ])),
            ));
  }
}
