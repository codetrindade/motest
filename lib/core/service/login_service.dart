import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/model/term.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/login_data.dart';
import 'package:moveme/model/token.dart';
import 'package:moveme/model/user.dart';
import 'package:moveme/settings.dart';

class LoginService extends BaseService {
  Api _api;

  LoginService() {
    this._api = locator.get<Api>();
  }

  Future<User> login(LoginData model) async {
    return User.fromJson(getResponse(await _api.post('login', model.toString())));
  }

  Future<Token> forgot(LoginData model) async {
    return Token.fromJson(getResponse(await _api.post('forgot', model.toString())));
  }

  Future<Term> getTerm() async {
    return Term.fromJson(getResponse(await _api.getOutBaseUrl(Settings.termUrl)));
  }
}