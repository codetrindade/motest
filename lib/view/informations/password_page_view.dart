import 'package:moveme/model/response_server.dart';

abstract class PasswordPageView {

  void onPasswordSuccess(ResponseServer message);

  void onPasswordError(String error);

}