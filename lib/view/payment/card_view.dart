import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/response_server.dart';

abstract class CardView extends BaseView {
  void onAddCardComplete(ResponseServer message);

  void onAddCardError(String error);
}
