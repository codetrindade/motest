import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/chat.dart';
import 'package:moveme/model/response_server.dart';

abstract class ActiveTripView extends BaseView {
  void onError(String message);

  void onCancelSuccess(ResponseServer result);

  void onGetChatSuccess(Chat data);
}