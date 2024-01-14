import 'package:moveme/app_state.dart';
import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/service/address_service.dart';
import 'package:moveme/service/injector_service.dart';

class AppStatePresenter extends BasePresenter {
  AppStateView _view;
  AddressService _addressService;

  AppStatePresenter(this._view) {
    super.view = _view;
    _addressService = new Injector().addressService;
  }

  void getAddressList() {
    _addressService.getList()
        .then((data) => _view.onAddressListSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}