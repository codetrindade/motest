import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/core/model/term.dart';
import 'package:moveme/core/service/login_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/login_data.dart';
import 'package:moveme/model/user.dart';

class LoginBloc extends BaseBloc {
  User model;
  var loginService = locator.get<LoginService>();
  bool showPassword = false;
  Term term;

  login(String email, String password) async {
    try {
      setLoading(true);
      var modelLogin = LoginData(email: email, password: password);
      var user = await loginService.login(modelLogin);

      eventBus.fire(AppLoginEvent(user));
    } catch (e) {
      super.onError(e);
    } finally {
      Future.delayed(Duration(seconds: 3), () => setLoading(false));
    }
  }

  forgot(String email) async {
    try {
      setLoading(true);
      var modelLogin = LoginData(email: email);
      await loginService.forgot(modelLogin);
      dialogService.showDialog(
          'Sucesso', 'Verifique seu em seu e-mail as instruções para recuperação da senha');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getTerm() async {
    try {
      setLoading(true);
      term = await loginService.getTerm();
    } catch(e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}