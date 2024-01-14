import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/service/user_service.dart';
import 'package:moveme/view/login/sms_page_view.dart';

class SmsPresenter extends BasePresenter {
  SmsPageView _view;
  UserService _service;

  SmsPresenter(this._view) {
    _service = new Injector().userService;
  }

  void confirmSms(String code, String phone) {
    _service
        .confirmSms(code, phone)
        .then((data) => _view.onSmsSuccess(data))
        .catchError((error) =>
        super.onErrorBeforeLogin(error, (message) => _view.onError(message)));
  }
}