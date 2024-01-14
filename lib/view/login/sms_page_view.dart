import 'package:moveme/model/response_server.dart';
import 'package:moveme/model/token.dart';
import 'package:moveme/model/user.dart';

abstract class SmsPageView {
  void onSmsSuccess(ResponseServer response);

  void onError(String error);
}