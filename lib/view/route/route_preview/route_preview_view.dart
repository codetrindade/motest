import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/payment.dart';
import 'package:moveme/model/preview.dart';

abstract class RoutePreviewView extends BaseView {

  void onError(String message);

  void onGetPreviewSuccess(Preview preview);

  void onListPaymentSuccess(List<Payment> payments);
}