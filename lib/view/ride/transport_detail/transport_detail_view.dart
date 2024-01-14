import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/chat.dart';
import 'package:moveme/model/response_server.dart';

abstract class TransportDetailView extends BaseView {
  void onApplySuccess(ResponseServer response);

  void onCancelRideSuccess(ResponseServer response);

  void onChatSuccess(Chat data);
}