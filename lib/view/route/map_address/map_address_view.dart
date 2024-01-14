import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/address.dart';

abstract class MapAddressView extends BaseView {

  void onError(String message);

  void onGetFromCoordinatesSuccess(Address address);
}