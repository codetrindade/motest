import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/address.dart';

abstract class AddressRoutePageView extends BaseView {

  void onError(String message);

  void onGetAutoCompleteResultsSuccess(List<Address> result);
}