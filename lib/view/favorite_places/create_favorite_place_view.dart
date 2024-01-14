import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/response_server.dart';

abstract class CreateFavoritePlaceView extends BaseView {
  void onError(String message);

  void onCreateFavoritePlaceSuccess(Address address);

  void onDeleteFavoritePlaceSuccess();

  void onGetAutoCompleteResultsSuccess(List<Address> result);

  void onRemoveSuccess(ResponseServer result);
}