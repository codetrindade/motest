import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/presenter/password_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/informations/password_page_view.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends BaseState<PasswordPage> implements PasswordPageView {
  PasswordPresenter _presenter;

  var _oldPassword = TextEditingController();
  var _newPassword = TextEditingController();
  var _confirmPassword = TextEditingController();

  var _oldPasswordFocus = FocusNode();
  var _newPasswordFocus = FocusNode();
  var _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    _oldPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  _PasswordPageState() {
    _presenter = PasswordPresenter(this);
  }

  void onSavePassword() {
    if (_oldPassword.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha a senha antiga');
      FocusScope.of(context).requestFocus(_oldPasswordFocus);
      return;
    }
    if (_newPassword.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha a nova senha');
      FocusScope.of(context).requestFocus(_newPasswordFocus);
      return;
    }
    if (_confirmPassword.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha a confirmação de senha');
      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
      return;
    }
    if (_newPassword.text != _confirmPassword.text) {
      Util.showMessage(context, 'Atenção', 'Senhas não conferem');
      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
      return;
    }

    Util.showLoading();
    _presenter.password(_oldPassword.text, _newPassword.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Alterar Senha',
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        callback: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _oldPassword,
              focusNode: _oldPasswordFocus,
              style: AppTextStyle.textPurpleExtraSmall,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: AppSizes.inputPadding,
                labelText: 'Senha atual',
                labelStyle: AppTextStyle.textPurpleExtraSmall,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15.0),
              height: 1.0,
              color: AppColors.colorPrimary,
            ),
            TextField(
              controller: _newPassword,
              focusNode: _newPasswordFocus,
              style: AppTextStyle.textPurpleExtraSmall,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: AppSizes.inputPadding,
                labelText: 'Nova senha',
                labelStyle: AppTextStyle.textPurpleExtraSmall,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _confirmPassword,
              focusNode: _confirmPasswordFocus,
              style: AppTextStyle.textPurpleExtraSmall,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: AppSizes.inputPadding,
                labelText: 'Confirme a senha',
                labelStyle: AppTextStyle.textPurpleExtraSmall,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: onSavePassword,
                child: Container(
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(color: AppColors.colorPrimary, borderRadius: AppSizes.buttonCorner),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('Salvar nova senha', style: AppTextStyle.textWhiteExtraSmallBold)],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  @override
  void onPasswordError(String error) {
    Util.closeLoading();
    Util.showMessage(context, 'Erro', error);
  }

  @override
  void onPasswordSuccess(ResponseServer message) {
    Util.closeLoading();
    Util.showMessage(context, 'Sucesso', message.message);
    Navigator.pop(context);
  }
}
