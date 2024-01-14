import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/service/user_service.dart';
import 'package:moveme/view/informations/password_page_view.dart';

class PasswordPresenter extends BasePresenter{
  PasswordPageView _view;
  UserService _service;

  PasswordPresenter(this._view) {
    _service = new Injector().userService;
  }

  void password(String oldPassword, String password) {
    _service
        .password(oldPassword, password)
        .then((data) => _view.onPasswordSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onPasswordError(message)));
  }

}