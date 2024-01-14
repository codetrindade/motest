import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/service/address_service.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/view/address_route/address_route_page_view.dart';

class AddressRoutePagePresenter extends BasePresenter {
  AddressRoutePageView _view;
  AddressService _addressService;

  AddressRoutePagePresenter(this._view) {
    super.view = _view;
    _addressService = new Injector().addressService;
  }

  void getAutoCompleteResults(Address address) {
    _addressService.getAutoCompleteResults(address)
        .then((data) => _view.onGetAutoCompleteResultsSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}